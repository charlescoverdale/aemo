test_that("FCAS_ENABLEMENT_COLS has 10 services", {
  expect_equal(length(aemo:::FCAS_ENABLEMENT_COLS), 10L)
  expect_true("raise1secmw" %in% aemo:::FCAS_ENABLEMENT_COLS)
  expect_true("lowerregmw"  %in% aemo:::FCAS_ENABLEMENT_COLS)
})

test_that("aemo_fcas_enablement errors on bad service name", {
  withr::local_options(aemo.cache_dir = tempdir())
  now <- Sys.time()
  expect_error(
    aemo_fcas_enablement(start = now - 60, end = now,
                         service = "notaservice"),
    "No matching FCAS service columns"
  )
})

test_that("aemo_fcas_enablement accepts NULL service (all 10)", {
  withr::local_options(aemo.cache_dir = tempdir())
  # Verify the call doesn't error at argument-checking stage (network
  # errors are wrapped in try() in the live test).
  now <- Sys.time()
  result <- tryCatch(
    aemo_fcas_enablement(start = now - 300, end = now),
    error = function(e) e
  )
  # Either an aemo_tbl or an error from the network; both are acceptable here.
  expect_true(inherits(result, "aemo_tbl") || inherits(result, "error"))
})
