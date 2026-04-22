test_that("aemo_parse_csv parses a minimal DISPATCH_PRICE block", {
  tmp <- tempfile(fileext = ".csv")
  writeLines(c(
    'C,NEMP.WORLD,...,test,...',
    'I,DISPATCH,PRICE,1,SETTLEMENTDATE,REGIONID,RRP',
    'D,DISPATCH,PRICE,1,"2024/06/01 00:05:00",NSW1,100.50',
    'D,DISPATCH,PRICE,1,"2024/06/01 00:10:00",NSW1,102.75',
    'D,DISPATCH,PRICE,1,"2024/06/01 00:05:00",VIC1,95.00',
    'F,DISPATCH,PRICE,1,3'
  ), tmp)
  on.exit(unlink(tmp), add = TRUE)

  parsed <- aemo:::aemo_parse_csv(tmp)
  expect_true("dispatch_price" %in% names(parsed))
  df <- parsed$dispatch_price
  expect_equal(nrow(df), 3L)
  expect_true(all(c("settlementdate", "regionid", "rrp") %in% names(df)))
})

test_that("aemo_parse_csv handles multiple tables in one file", {
  tmp <- tempfile(fileext = ".csv")
  writeLines(c(
    'C,header',
    'I,DISPATCH,PRICE,1,COL_A,COL_B',
    'D,DISPATCH,PRICE,1,1,2',
    'I,DISPATCH,DEMAND,1,COL_C,COL_D',
    'D,DISPATCH,DEMAND,1,3,4',
    'F,footer'
  ), tmp)
  on.exit(unlink(tmp), add = TRUE)

  parsed <- aemo:::aemo_parse_csv(tmp)
  expect_setequal(names(parsed), c("dispatch_price", "dispatch_demand"))
  expect_equal(nrow(parsed$dispatch_price), 1L)
  expect_equal(nrow(parsed$dispatch_demand), 1L)
})

test_that("aemo_parse_csv tolerates ragged D rows", {
  tmp <- tempfile(fileext = ".csv")
  writeLines(c(
    'C,header',
    'I,DISPATCH,PRICE,1,A,B,C',
    'D,DISPATCH,PRICE,1,1,2,3',
    'D,DISPATCH,PRICE,1,4,5',
    'F,footer'
  ), tmp)
  on.exit(unlink(tmp), add = TRUE)
  parsed <- aemo:::aemo_parse_csv(tmp)
  expect_equal(nrow(parsed$dispatch_price), 2L)
  expect_equal(parsed$dispatch_price$c, c("3", NA_character_))
})
