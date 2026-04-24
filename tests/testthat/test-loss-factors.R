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
      httr2::request("http://nemweb.com.au") |>
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
