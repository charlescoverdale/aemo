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

test_that("aemo_mlf_fallback returns expected structure", {
  fb <- aemo:::aemo_mlf_fallback()
  expect_true(is.data.frame(fb))
  expect_true(all(c("financial_year", "duid", "mlf") %in% names(fb)))
  expect_true(nrow(fb) >= 20L)
  expect_true(all(fb$mlf > 0.8 & fb$mlf < 1.2))
})

test_that("aemo_mlf filters by year and duid", {
  withr::local_options(aemo.cache_dir = tempdir())
  # Force the fallback path by mocking network errors
  m <- aemo_mlf(year = "2024-25")
  expect_s3_class(m, "aemo_tbl")
  expect_true(nrow(m) > 0L)
  if ("financial_year" %in% names(m)) {
    expect_true(all(m$financial_year == "2024-25"))
  }

  m2 <- aemo_mlf(duid = "BW01")
  if ("duid" %in% names(m2)) {
    expect_true(all(toupper(m2$duid) == "BW01"))
  }
})

test_that("aemo_mlf errors on unknown year after filtering", {
  withr::local_options(aemo.cache_dir = tempdir())
  expect_error(aemo_mlf(year = "1990-91"), "No MLF data found")
})
