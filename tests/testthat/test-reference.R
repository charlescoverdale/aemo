test_that("aemo_regions returns all five NEM regions", {
  r <- aemo_regions()
  expect_s3_class(r, "aemo_tbl")
  expect_equal(nrow(r), 5L)
  expect_setequal(r$region, c("NSW1", "QLD1", "SA1", "TAS1", "VIC1"))
})

test_that("aemo_regions distinguishes market and wall timezones", {
  r <- aemo_regions()
  # Market timezone is fixed AEST (Australia/Brisbane, no DST)
  # for every region.
  expect_true(all(r$market_timezone == "Australia/Brisbane"))
  # Wall timezones differ by region (NSW/VIC/TAS/SA observe DST).
  expect_gt(length(unique(r$wall_timezone)), 1L)
})

test_that("aemo_interconnectors returns seven interconnectors", {
  i <- aemo_interconnectors()
  expect_s3_class(i, "aemo_tbl")
  expect_equal(nrow(i), 7L)
  expect_true(all(c("interconnector_id", "from_region", "to_region") %in% names(i)))
  expect_true("V-S-N" %in% i$interconnector_id)  # Project EnergyConnect
})

test_that("aemo_units returns the fallback table", {
  u <- aemo_units()
  expect_s3_class(u, "aemo_tbl")
  expect_true("duid" %in% names(u))
  expect_gt(nrow(u), 0L)
})
