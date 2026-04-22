test_that("aemo_bids requires duid", {
  expect_error(aemo_bids(start = "2024-06-01", end = "2024-06-02"),
               "duid")
})

test_that("aemo_bids enforces span guard", {
  expect_error(
    aemo_bids(duid = "BW01", start = "2024-01-01", end = "2024-06-01"),
    "allow_large"
  )
})

test_that("aemo_bids validates resolution", {
  expect_error(aemo_bids(duid = "BW01", start = "2024-06-01",
                          end = "2024-06-02", resolution = "minute"))
})
