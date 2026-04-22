test_that("aemo_gas validates market", {
  expect_error(aemo_gas(market = "lng", start = "2024-06-01", end = "2024-06-02"))
})
