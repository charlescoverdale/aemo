test_that("aemo_bids requires duid", {
  expect_error(aemo_bids(start = "2024-06-01", end = "2024-06-02"),
               "duid")
})

test_that("aemo_bids enforces span guard on BIDPEROFFER (period / joined)", {
  # v0.2.0: guard applies only when BIDPEROFFER_D is touched, not for the
  # small BIDDAYOFFER_D daily resolution. BIDPEROFFER monthly archives
  # are multi-GB; BIDDAYOFFER files are small.
  expect_error(
    aemo_bids(duid = "BW01", start = "2024-01-01", end = "2024-06-01",
              resolution = "period"),
    "allow_large"
  )
  expect_error(
    aemo_bids(duid = "BW01", start = "2024-01-01", end = "2024-06-01",
              resolution = "joined"),
    "allow_large"
  )
})

test_that("aemo_bids validates resolution", {
  expect_error(aemo_bids(duid = "BW01", start = "2024-06-01",
                          end = "2024-06-02", resolution = "minute"))
})
