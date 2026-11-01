test_that("aemo_fy_label converts dates to FY strings correctly", {
  # January 2025 -> FY 2024-25
  expect_equal(aemo:::aemo_fy_label(as.Date("2025-01-15")), "2024-25")
  # August 2025 -> FY 2025-26
  expect_equal(aemo:::aemo_fy_label(as.Date("2025-08-01")), "2025-26")
  # July 1 boundary (first day of new FY)
  expect_equal(aemo:::aemo_fy_label(as.Date("2024-07-01")), "2024-25")
  # June 30 boundary (last day of old FY)
  expect_equal(aemo:::aemo_fy_label(as.Date("2025-06-30")), "2024-25")
  # POSIXct input
  p <- as.POSIXct("2025-03-01 14:00:00", tz = "Australia/Brisbane")
  expect_equal(aemo:::aemo_fy_label(p), "2024-25")
})

test_that("aemo_mlf aborts when MMSDM is unreachable (no fallback)", {
  # v0.2.0 removed the indicative MLF fallback: unsourced values are a
  # correctness trap. MMSDM being unreachable must abort rather than
  # return invented numbers. This test is skipped when MMSDM is live.
  testthat::skip_on_cran()
  testthat::skip_if_not(
    identical(Sys.getenv("AEMO_FORCE_OFFLINE_TESTS"), "true"),
    "Offline-abort test runs only when AEMO_FORCE_OFFLINE_TESTS=true"
  )
  withr::local_options(aemo.cache_dir = tempdir(),
                       aemo.base_url = "http://127.0.0.1:1")
  expect_error(aemo_mlf(year = "2024-25"),
               "Could not retrieve TRANSMISSIONLOSSFACTOR")
})

test_that("aemo_mlf filters by year and duid when MMSDM reachable", {
  testthat::skip_on_cran()
  skip_if_not(
    isTRUE(tryCatch({
      httr2::request("https://nemweb.com.au/Reports/Current/") |>
        httr2::req_timeout(5) |>
        httr2::req_perform()
      TRUE
    }, error = function(e) FALSE)),
    message = "NEMweb not reachable"
  )

  withr::local_options(aemo.cache_dir = tempdir())
  m <- tryCatch(aemo_mlf(year = "2024-25"), error = function(e) NULL)
  skip_if(is.null(m), "TRANSMISSIONLOSSFACTOR not in recent MMSDM archive")

  expect_s3_class(m, "aemo_tbl")
  expect_true(nrow(m) > 0L)
  if ("financial_year" %in% names(m)) {
    expect_true(all(m$financial_year == "2024-25"))
  }
})

test_that("MLFs come from the June file plus later revisions", {
  mlf_rows <- function(tlf, eff, ver, cp, changed) {
    data.frame(transmissionlossfactor = tlf, effectivedate = eff,
               versionno = ver, connectionpointid = cp, regionid = "NSW1",
               lastchanged = changed, secondary_tlf = "",
               stringsAsFactors = FALSE)
  }
  local_mocked_bindings(aemo_mmsdm_month = function(table, year, month) {
    if (year == "2025" && month == "06") {
      # The determination for 2025-26, and a June revision to 2024-25
      return(mlf_rows(c("0.95", "0.97"),
                      c("2025/07/01 00:00:00", "2025/06/12 00:00:00"),
                      c("1", "1"), c("AAA1", "BBB1"),
                      "2025/06/10 10:00:00"))
    }
    if (year == "2025" && month == "09") {
      # A mid-year revision of AAA1's 1 July factor
      return(mlf_rows("0.96", "2025/07/01 00:00:00", "2", "AAA1",
                      "2025/09/04 10:00:00"))
    }
    stop("not published")
  })
  df <- aemo:::aemo_fetch_mlf_mmsdm("2025-26")
  expect_equal(df$connectionpointid, "AAA1")
  expect_equal(df$mlf, 0.96)
})
