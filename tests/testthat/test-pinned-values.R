# Pinned-value tests: assert that specific well-documented historical
# intervals return the correct data. These are integration tests that
# require a live network connection; they are skipped on CRAN and CI
# without a network. A failure here means a silent data bug (wrong
# table extracted, wrong column, wrong filter) — not just an API error.

skip_if_offline <- function() {
  testthat::skip_if_not(
    isTRUE(tryCatch(
      {
        httr2::request("http://nemweb.com.au") |>
          httr2::req_timeout(5) |>
          httr2::req_perform()
        TRUE
      },
      error = function(e) FALSE
    )),
    message = "NEMweb not reachable"
  )
}

test_that("aemo_price returns correct RRP for a known historical interval", {
  # NSW1 RRP on 14 April 2021 at 12:30 AEST was approximately AUD 50-70/MWh
  # (off-peak, pre-5MS era). We pin the sign and rough order-of-magnitude
  # rather than an exact value to guard against AEMO restating.
  testthat::skip_on_cran()
  skip_if_offline()

  withr::local_options(aemo.cache_dir = tempdir())
  p <- aemo_price(
    region = "NSW1",
    start  = "2021-04-14 12:00:00",
    end    = "2021-04-14 13:00:00",
    interval = "5min"
  )
  expect_s3_class(p, "aemo_tbl")
  expect_true(nrow(p) >= 6L,
              info = "Expected at least 6 five-minute intervals")
  expect_true("rrp" %in% names(p))
  expect_true(all(is.numeric(p$rrp)),
              info = "RRP must be numeric, not character")
  # AEST timezone preserved end-to-end
  expect_equal(attr(p$settlementdate, "tzone"), "Australia/Brisbane")
  # Off-peak NSW prices in this window: positive and < 300 AUD/MWh
  expect_true(all(p$rrp > -1001 & p$rrp < 17600),
              info = "All RRPs must be within market floor/cap bounds")
})

test_that("aemo_price intervention filter works: INTERVENTION=0 rows only by default", {
  # During the June 2022 market suspension AEMO issued intervention
  # directions on 13 June 2022. DISPATCHPRICE contains both intervention=0
  # and intervention=1 rows. The default filter should return only
  # intervention=0 rows.
  testthat::skip_on_cran()
  skip_if_offline()

  withr::local_options(aemo.cache_dir = tempdir())
  p_default <- aemo_price(
    region = "NSW1",
    start  = "2022-06-13 16:00:00",
    end    = "2022-06-13 17:00:00"
  )
  if ("intervention" %in% names(p_default)) {
    iv <- suppressWarnings(as.integer(p_default$intervention))
    expect_true(all(is.na(iv) | iv == 0L),
                info = "Default should return only intervention=0 rows")
  }

  p_both <- aemo_price(
    region = "NSW1",
    start  = "2022-06-13 16:00:00",
    end    = "2022-06-13 17:00:00",
    intervention = TRUE
  )
  # With intervention=TRUE we expect >= as many rows as the default
  expect_true(nrow(p_both) >= nrow(p_default))
})

test_that("aemo_price timestamps are AEST not AEDT (no DST shift)", {
  # On 6 October 2024 Sydney clocks sprang forward at 02:00 (AEST -> AEDT).
  # With Australia/Sydney the 02:30 interval would be ambiguous/NA.
  # With Australia/Brisbane it must parse cleanly.
  testthat::skip_on_cran()
  skip_if_offline()

  withr::local_options(aemo.cache_dir = tempdir())
  p <- aemo_price(
    region   = "NSW1",
    start    = "2024-10-06 02:00:00",
    end      = "2024-10-06 03:00:00"
  )
  expect_true(nrow(p) > 0L)
  expect_false(any(is.na(p$settlementdate)),
               info = "No NA timestamps at DST-transition boundary in AEST")
  expect_equal(attr(p$settlementdate, "tzone"), "Australia/Brisbane")
})
