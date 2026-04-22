test_that("aemo_regions returns all five NEM regions", {
  r <- aemo_regions()
  expect_s3_class(r, "aemo_tbl")
  expect_equal(nrow(r), 5L)
  expect_setequal(r$region, c("NSW1", "QLD1", "SA1", "TAS1", "VIC1"))
})

test_that("aemo_interconnectors returns six interconnectors", {
  i <- aemo_interconnectors()
  expect_s3_class(i, "aemo_tbl")
  expect_equal(nrow(i), 6L)
  expect_true(all(c("interconnector_id", "from_region", "to_region") %in% names(i)))
})

test_that("aemo_units returns the fallback table", {
  u <- aemo_units()
  expect_s3_class(u, "aemo_tbl")
  expect_true("duid" %in% names(u))
  expect_gt(nrow(u), 0L)
})
