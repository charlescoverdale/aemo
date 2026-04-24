test_that("aemo_filter_as_of selects rows active on as_of date", {
  df <- data.frame(
    duid = c("BW01", "LD01", "HPS1", "BESS_NEW"),
    start_date = as.POSIXct(c("2010-01-01", "1990-01-01", "2005-01-01",
                               "2024-06-01"),
                              tz = "Australia/Brisbane"),
    end_date = as.POSIXct(c("2999-12-31", "2023-04-28", "2999-12-31",
                              "2999-12-31"),
                            tz = "Australia/Brisbane"),
    stringsAsFactors = FALSE
  )

  # Before Liddell retirement: Liddell in, new BESS not yet
  out <- aemo:::aemo_filter_as_of(df,
                                   as_of = as.POSIXct("2022-03-01",
                                                        tz = "Australia/Brisbane"))
  expect_true("LD01" %in% out$duid)
  expect_false("BESS_NEW" %in% out$duid)

  # Mid-2024: Liddell out, new BESS in
  out2 <- aemo:::aemo_filter_as_of(df,
                                    as_of = as.POSIXct("2024-08-01",
                                                         tz = "Australia/Brisbane"))
  expect_false("LD01" %in% out2$duid)
  expect_true("BESS_NEW" %in% out2$duid)
  expect_true("BW01" %in% out2$duid)
})

test_that("aemo_filter_as_of treats MMSDM 2999 sentinel as open-ended", {
  df <- data.frame(
    duid = "X",
    start_date = as.POSIXct("2020-01-01", tz = "Australia/Brisbane"),
    end_date = as.POSIXct("2999-12-31", tz = "Australia/Brisbane"),
    stringsAsFactors = FALSE
  )
  out <- aemo:::aemo_filter_as_of(df,
                                   as_of = as.POSIXct("2024-06-01",
                                                        tz = "Australia/Brisbane"))
  expect_equal(nrow(out), 1L)
})
