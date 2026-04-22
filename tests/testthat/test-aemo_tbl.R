test_that("new_aemo_tbl attaches provenance", {
  df <- data.frame(a = 1:2)
  x <- aemo:::new_aemo_tbl(df, title = "T", source = "http://nemweb.com.au")
  expect_s3_class(x, "aemo_tbl")
  expect_equal(attr(x, "aemo_title"), "T")
  expect_match(attr(x, "aemo_licence"), "AEMO")
})

test_that("new_aemo_tbl requires a data frame", {
  expect_error(aemo:::new_aemo_tbl(list()))
})

test_that("print.aemo_tbl emits header", {
  df <- data.frame(a = 1)
  x <- aemo:::new_aemo_tbl(df, title = "Demo",
                            retrieved = as.POSIXct("2026-01-01", tz = "UTC"))
  out <- capture.output(print(x))
  expect_true(any(grepl("aemo_tbl: Demo", out, fixed = TRUE)))
  expect_true(any(grepl("AEMO", out)))
})

test_that("print.aemo_tbl returns x invisibly", {
  df <- data.frame(a = 1)
  x <- aemo:::new_aemo_tbl(df)
  tf <- tempfile()
  sink(tf)
  wv <- withVisible(print(x))
  sink()
  unlink(tf)
  expect_false(wv$visible)
  expect_identical(wv$value, x)
})
