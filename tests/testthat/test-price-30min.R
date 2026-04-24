test_that("FIVE_MS_START is 2021-10-01 AEST", {
  expect_equal(
    format(aemo:::FIVE_MS_START, "%Y-%m-%d", tz = "Australia/Brisbane"),
    "2021-10-01"
  )
  expect_equal(attr(aemo:::FIVE_MS_START, "tzone"), "Australia/Brisbane")
})

test_that("aemo_aggregate_to_30min groups 5-min prices to 30-min", {
  tz <- "Australia/Brisbane"
  # Six 5-min intervals ending 14:05 through 14:30 -> one 30-min row at 14:30
  times <- as.POSIXct(
    c("2024-01-15 14:05:00", "2024-01-15 14:10:00",
      "2024-01-15 14:15:00", "2024-01-15 14:20:00",
      "2024-01-15 14:25:00", "2024-01-15 14:30:00"),
    tz = tz
  )
  df <- data.frame(
    settlementdate = times,
    regionid = rep("NSW1", 6L),
    rrp = c(60, 65, 70, 55, 80, 50),
    stringsAsFactors = FALSE
  )
  out <- aemo:::aemo_aggregate_to_30min(df)

  expect_equal(nrow(out), 1L)
  expect_equal(
    format(out$settlementdate, "%H:%M", tz = tz),
    "14:30"
  )
  expect_equal(out$rrp, mean(c(60, 65, 70, 55, 80, 50)))
})

test_that("aemo_aggregate_to_30min handles on-boundary 14:00 correctly", {
  tz <- "Australia/Brisbane"
  # 14:00:00 is the last 5-min interval of the 13:30-14:00 trading period.
  # It must map to 14:00, NOT 14:30.
  times <- as.POSIXct(
    c("2024-01-15 13:35:00", "2024-01-15 13:40:00",
      "2024-01-15 13:45:00", "2024-01-15 13:50:00",
      "2024-01-15 13:55:00", "2024-01-15 14:00:00"),
    tz = tz
  )
  df <- data.frame(
    settlementdate = times,
    regionid = rep("NSW1", 6L),
    rrp = c(50, 55, 60, 65, 70, 75),
    stringsAsFactors = FALSE
  )
  out <- aemo:::aemo_aggregate_to_30min(df)

  expect_equal(nrow(out), 1L)
  expect_equal(
    format(out$settlementdate, "%H:%M", tz = tz),
    "14:00"
  )
  expect_equal(out$rrp, mean(c(50, 55, 60, 65, 70, 75)))
})

test_that("aemo_aggregate_to_30min handles multiple regions", {
  tz <- "Australia/Brisbane"
  times <- rep(
    as.POSIXct(c("2024-01-15 14:05:00", "2024-01-15 14:30:00"), tz = tz),
    each = 2L
  )
  df <- data.frame(
    settlementdate = times,
    regionid = rep(c("NSW1", "VIC1"), 2L),
    rrp = c(60, 55, 70, 65),
    stringsAsFactors = FALSE
  )
  out <- aemo:::aemo_aggregate_to_30min(df)
  # 2 regions × 1 trading interval = 2 rows
  expect_equal(nrow(out), 2L)
})

test_that("aemo_aggregate_to_30min returns df unchanged if no rrp column", {
  df <- data.frame(settlementdate = Sys.time(), other = 1)
  out <- aemo:::aemo_aggregate_to_30min(df)
  expect_equal(nrow(out), 1L)
})
