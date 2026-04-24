test_that("aemo_mmsdm_url builds correct PUBLIC_ARCHIVE pattern", {
  url <- aemo:::aemo_mmsdm_url("DUDETAILSUMMARY", "2025", "03")
  expect_true(grepl("PUBLIC_ARCHIVE%23DUDETAILSUMMARY%23FILE01%232025030", url))
  expect_true(grepl("^https://nemweb", url))

  url2 <- aemo:::aemo_mmsdm_url("TRANSMISSIONLOSSFACTOR", "2024", "11")
  expect_true(grepl("TRANSMISSIONLOSSFACTOR", url2))
  expect_true(grepl("%23FILE01%23", url2))
})

test_that("aemo_validate_region accepts valid codes", {
  expect_equal(aemo:::aemo_validate_region("nsw1"), "NSW1")
  expect_equal(aemo:::aemo_validate_region(c("nsw1", "vic1")),
               c("NSW1", "VIC1"))
})

test_that("aemo_validate_region rejects invalid codes", {
  expect_error(aemo:::aemo_validate_region("ACT1"))
  expect_error(aemo:::aemo_validate_region(c("NSW1", "XYZ")))
})

test_that("aemo_parse_time accepts character and POSIXct", {
  p <- aemo:::aemo_parse_time("2024-06-01")
  expect_s3_class(p, "POSIXct")
  q <- aemo:::aemo_parse_time(as.POSIXct("2024-06-01", tz = "UTC"))
  expect_s3_class(q, "POSIXct")
})

test_that("aemo_parse_time rejects garbage", {
  expect_error(aemo:::aemo_parse_time(1234))
})

test_that("aemo_parse_time uses AEST (no DST)", {
  # AEMO market time is fixed AEST. We use Australia/Brisbane
  # because it does not observe DST.
  p <- aemo:::aemo_parse_time("2024-12-01 10:00:00")
  expect_equal(format(p, "%Z", tz = aemo:::AEMO_TIMEZONE), "AEST")
  # DST-transition instant in Sydney civil time (2024-10-06
  # spring-forward 02:00 -> 03:00) exists in AEST.
  p2 <- aemo:::aemo_parse_time("2024-10-06 02:30:00")
  expect_s3_class(p2, "POSIXct")
  expect_false(is.na(p2))
})

test_that("aemo_file_timestamp extracts NEMweb filename timestamps", {
  names <- c(
    "PUBLIC_DISPATCHIS_202604210405_0000000513945454.zip",
    "PUBLIC_DISPATCHIS_20260420.zip",                      # Archive daily
    "NOT_A_NEMWEB_FILE.zip"
  )
  ts <- aemo:::aemo_file_timestamp(names)
  expect_equal(length(ts), 3L)
  expect_false(is.na(ts[1]))
  expect_false(is.na(ts[2]))
  expect_true(is.na(ts[3]))
  # The AEST timestamp for 202604210405 should be 2026-04-21 04:05 AEST.
  expect_equal(format(ts[1], "%Y-%m-%d %H:%M", tz = aemo:::AEMO_TIMEZONE),
               "2026-04-21 04:05")
})

test_that("aemo_parse_col_time handles AEMO CSV date formats", {
  x <- c("2024/06/01 00:05:00",
         "2024-06-01 00:05:00",
         "garbage",
         NA_character_)
  ts <- aemo:::aemo_parse_col_time(x)
  expect_equal(length(ts), 4L)
  expect_false(is.na(ts[1]))
  expect_false(is.na(ts[2]))
  expect_true(is.na(ts[3]))
  expect_true(is.na(ts[4]))
})

test_that("aemo_coerce_types coerces RRP and MW columns to numeric", {
  df <- data.frame(
    settlementdate = c("2024/06/01 00:05:00", "2024/06/01 00:10:00"),
    regionid = c("NSW1", "NSW1"),
    rrp = c("80.50", "102.75"),
    totaldemand = c("7500.0", "7520.5"),
    duid = c("BW01", "BW01"),
    intervention = c("0", "0"),
    stringsAsFactors = FALSE
  )
  out <- aemo:::aemo_coerce_types(df)
  expect_s3_class(out$settlementdate, "POSIXct")
  expect_true(is.numeric(out$rrp))
  expect_true(is.numeric(out$totaldemand))
  expect_equal(out$rrp, c(80.5, 102.75))
  # ID and flag columns stay character
  expect_true(is.character(out$duid))
  expect_true(is.character(out$intervention))
  expect_true(is.character(out$regionid))
})

test_that("aemo_apply_filters drops INTERVENTION = 1 rows by default", {
  df <- data.frame(
    settlementdate = rep(as.POSIXct("2024-06-01 00:05",
                                     tz = aemo:::AEMO_TIMEZONE), 3),
    regionid = c("NSW1", "NSW1", "VIC1"),
    intervention = c("0", "1", "0"),
    rrp = c(80, 999, 60),
    stringsAsFactors = FALSE
  )
  out <- aemo:::aemo_apply_filters(df, region = "NSW1",
                                    intervention = FALSE)
  expect_equal(nrow(out), 1L)
  expect_equal(out$rrp, 80)
})

test_that("aemo_apply_filters keeps INTERVENTION = 1 when requested", {
  df <- data.frame(
    settlementdate = rep(as.POSIXct("2024-06-01 00:05",
                                     tz = aemo:::AEMO_TIMEZONE), 2),
    regionid = c("NSW1", "NSW1"),
    intervention = c("0", "1"),
    rrp = c(80, 999),
    stringsAsFactors = FALSE
  )
  out <- aemo:::aemo_apply_filters(df, region = "NSW1",
                                    intervention = TRUE)
  expect_equal(nrow(out), 2L)
})

test_that("aemo_clean_names snakecases", {
  expect_equal(aemo:::aemo_clean_names(c("Settlement Date", "RRP($)")),
               c("settlement_date", "rrp"))
})
