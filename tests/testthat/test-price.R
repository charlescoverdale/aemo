test_that("aemo_price validates region", {
  expect_error(aemo_price("ACT1", "2024-06-01", "2024-06-02"))
})

test_that("aemo_price validates interval", {
  expect_error(aemo_price("NSW1", "2024-06-01", "2024-06-02", interval = "1min"))
})

test_that("aemo_price requires end >= start", {
  expect_error(aemo_price("NSW1", "2024-06-02", "2024-06-01"))
})

test_that("aemo_price live fetch", {
  skip_on_cran()
  skip_if_offline()
  skip_if(Sys.getenv("AEMO_LIVE_TESTS") != "true",
          "Live network tests disabled by default.")

  p <- aemo_price("NSW1", "2024-06-01", "2024-06-01 01:00:00")
  expect_s3_class(p, "aemo_tbl")
})
