test_that("aemo_validate_region accepts valid codes", {
  expect_equal(aemo:::aemo_validate_region("nsw1"), "NSW1")
  expect_equal(aemo:::aemo_validate_region(c("nsw1", "vic1")), c("NSW1", "VIC1"))
})

test_that("aemo_validate_region rejects invalid codes", {
  expect_error(aemo:::aemo_validate_region("ACT1"))
  expect_error(aemo:::aemo_validate_region(c("NSW1", "XYZ")))
})

test_that("aemo_parse_time accepts character and POSIXct", {
  p <- aemo:::aemo_parse_time("2024-06-01")
  expect_s3_class(p, "POSIXct")
  q <- aemo:::aemo_parse_time(as.POSIXct("2024-06-01", tz = "UTC"))
  expect_s3_class(q, "POSIXct")
})

test_that("aemo_parse_time rejects garbage", {
  expect_error(aemo:::aemo_parse_time(1234))
})

test_that("aemo_clean_names snakecases", {
  expect_equal(aemo:::aemo_clean_names(c("Settlement Date", "RRP($)")),
               c("settlement_date", "rrp"))
})
