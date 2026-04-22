test_that("aemo_predispatch validates horizon", {
  expect_error(aemo_predispatch("NSW1", horizon = "annual"))
})

test_that("aemo_pasa validates horizon", {
  expect_error(aemo_pasa(horizon = "long"))
})

test_that("aemo_pasa validates region when provided", {
  expect_error(aemo_pasa(horizon = "short", region = "XYZ"))
})
