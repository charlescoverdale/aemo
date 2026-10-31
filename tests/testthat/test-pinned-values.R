# Integration tests on real intervals: assert that dispatch prices come
# back with the right structure, types, bounds, filters and time zone.
# They need a live network connection and are skipped on CRAN and
# offline. A failure here means a silent data bug (wrong table extracted,
# wrong column, wrong filter), not just an API error.
#
# NEMweb keeps about 13 months of daily archives and 30 days of current
# files, so the dates are relative to today: fixed historical dates age
# out of NEMweb and the tests could never pass. (They previously used
# 2021-22 dates and a reachability probe on the site root, which now
# redirects, so they were always skipped.)

skip_if_offline <- function() {
  testthat::skip_if_not(
    isTRUE(tryCatch(
      {
        httr2::request("https://nemweb.com.au/Reports/Current/") |>
          httr2::req_timeout(5) |>
          httr2::req_perform()
        TRUE
      },
      error = function(e) FALSE
    )),
    message = "NEMweb not reachable"
  )
}

# A date `days_ago` days before today in market time (AEST).
nem_day <- function(days_ago) {
  format(as.Date(Sys.time(), tz = "Australia/Brisbane") - days_ago)
}

test_that("aemo_price returns well-formed 5-minute prices from the Archive", {
  testthat::skip_on_cran()
  skip_if_offline()

  withr::local_options(aemo.cache_dir = tempdir())
  day <- nem_day(60)
  p <- aemo_price(
    region = "NSW1",
    start  = paste(day, "12:00:00"),
    end    = paste(day, "13:00:00"),
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
  expect_true(all(p$rrp > -1001 & p$rrp < 20300),
              info = "All RRPs must be within market floor/cap bounds")
})

test_that("aemo_price intervention filter works: INTERVENTION=0 rows only by default", {
  testthat::skip_on_cran()
  skip_if_offline()

  withr::local_options(aemo.cache_dir = tempdir())
  day <- nem_day(45)
  p_default <- aemo_price(
    region = "NSW1",
    start  = paste(day, "16:00:00"),
    end    = paste(day, "17:00:00")
  )
  if ("intervention" %in% names(p_default)) {
    iv <- suppressWarnings(as.integer(p_default$intervention))
    expect_true(all(is.na(iv) | iv == 0L),
                info = "Default should return only intervention=0 rows")
  }

  p_both <- aemo_price(
    region = "NSW1",
    start  = paste(day, "16:00:00"),
    end    = paste(day, "17:00:00"),
    intervention = TRUE
  )
  expect_true(nrow(p_both) >= nrow(p_default))
})

test_that("aemo_price timestamps are AEST not AEDT (no DST shift)", {
  # Sydney clocks spring forward at 02:00 on the first Sunday of October.
  # With Australia/Sydney the 02:30 interval would be ambiguous or NA;
  # with Australia/Brisbane it must parse cleanly. Use the most recent
  # transition, provided NEMweb still holds it.
  testthat::skip_on_cran()
  skip_if_offline()

  today <- as.Date(Sys.time(), tz = "Australia/Brisbane")
  yr <- as.integer(format(today, "%Y"))
  first_sunday_oct <- function(y) {
    d <- as.Date(sprintf("%d-10-01", y))
    d + (7L - as.integer(format(d, "%u"))) %% 7L
  }
  dst <- first_sunday_oct(yr)
  if (dst >= today) dst <- first_sunday_oct(yr - 1L)
  skip_if(today - dst > 360, "Most recent DST transition is outside the NEMweb archive")

  withr::local_options(aemo.cache_dir = tempdir())
  p <- aemo_price(
    region   = "NSW1",
    start    = paste(dst, "02:00:00"),
    end      = paste(dst, "03:00:00")
  )
  expect_true(nrow(p) > 0L)
  expect_false(any(is.na(p$settlementdate)),
               info = "No NA timestamps at DST-transition boundary in AEST")
  expect_equal(attr(p$settlementdate, "tzone"), "Australia/Brisbane")
})
