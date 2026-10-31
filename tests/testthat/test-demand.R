test_that("aemo_demand validates region", {
  expect_error(aemo_demand("ACT1", "2024-06-01", "2024-06-02"))
})

test_that("aemo_demand validates measure", {
  expect_error(aemo_demand("NSW1", "2024-06-01", "2024-06-02",
                           measure = "instantaneous"))
})

test_that("aemo_demand live fetch", {
  skip_on_cran()
  skip_if_offline()
  skip_if(Sys.getenv("AEMO_LIVE_TESTS") != "true",
          "Live network tests disabled by default.")
  # NEMweb holds about 13 months, so the date is relative to today.
  day <- format(as.Date(Sys.time(), tz = "Australia/Brisbane") - 3)
  d <- aemo_demand("VIC1", day, paste(day, "01:00:00"))
  expect_s3_class(d, "aemo_tbl")
})
