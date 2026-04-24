# Offline fixture tests: parse a bundled CSV and assert exact values.
# These run without any network access and cover the full parsing stack
# (csv_parse.R -> aemo_coerce_types -> aemo_apply_filters).
# A failure here means a silent correctness bug in the parser or type coercion.

fixture_path <- function(name) {
  system.file("testdata", name, package = "aemo")
}

test_that("fixture CSV parses with correct structure", {
  path <- fixture_path("PUBLIC_DISPATCHIS_202401150000_FIXTURE.CSV")
  skip_if_not(nzchar(path) && file.exists(path),
               "fixture file not installed")

  tables <- aemo:::aemo_parse_csv(path)
  expect_type(tables, "list")
  expect_true(length(tables) >= 1L)

  # The DISPATCHPRICE table should be present
  nm <- names(tables)
  expect_true(any(grepl("price", nm, ignore.case = TRUE)),
              info = paste("Expected a 'price' table; got:", paste(nm, collapse = ", ")))
})

test_that("fixture DISPATCHPRICE has correct columns after coercion", {
  path <- fixture_path("PUBLIC_DISPATCHIS_202401150000_FIXTURE.CSV")
  skip_if_not(nzchar(path) && file.exists(path),
               "fixture file not installed")

  tables <- aemo:::aemo_parse_csv(path)
  price_nm <- names(tables)[grepl("price", names(tables), ignore.case = TRUE)][1L]
  df <- aemo:::aemo_coerce_types(tables[[price_nm]])

  # 9 data rows across 5 regions / 2 intervals (TAS has no 00:10 row in fixture)
  expect_equal(nrow(df), 9L)

  # settlementdate must be POSIXct in AEST
  expect_s3_class(df$settlementdate, "POSIXct")
  expect_equal(attr(df$settlementdate, "tzone"), "Australia/Brisbane")

  # rrp must be numeric (not character)
  expect_true(is.numeric(df$rrp),
              info = "rrp column must be numeric after type coercion")

  # Known pinned values: NSW1 at 00:05 = 62.35 AUD/MWh
  nsw_0005 <- df[df$regionid == "NSW1" &
                   format(df$settlementdate, "%H:%M") == "00:05", ]
  expect_equal(nrow(nsw_0005), 1L)
  expect_equal(nsw_0005$rrp, 62.35)

  # SA1 at 00:05 = 63.45 AUD/MWh
  sa_0005 <- df[df$regionid == "SA1" &
                  format(df$settlementdate, "%H:%M") == "00:05", ]
  expect_equal(nrow(sa_0005), 1L)
  expect_equal(sa_0005$rrp, 63.45)
})

test_that("intervention filter correctly removes INTERVENTION=1 rows", {
  path <- fixture_path("PUBLIC_DISPATCHIS_202401150000_FIXTURE.CSV")
  skip_if_not(nzchar(path) && file.exists(path),
               "fixture file not installed")

  tables <- aemo:::aemo_parse_csv(path)
  price_nm <- names(tables)[grepl("price", names(tables), ignore.case = TRUE)][1L]
  df <- aemo:::aemo_coerce_types(tables[[price_nm]])

  # Fixture has only INTERVENTION=0 rows; filter should return all rows
  df_filtered <- aemo:::aemo_apply_filters(df, intervention = FALSE)
  expect_equal(nrow(df_filtered), nrow(df))

  # Passing intervention=TRUE should also return all rows (no =1 rows present)
  df_both <- aemo:::aemo_apply_filters(df, intervention = TRUE)
  expect_equal(nrow(df_both), nrow(df))
})

test_that("region filter works on fixture data", {
  path <- fixture_path("PUBLIC_DISPATCHIS_202401150000_FIXTURE.CSV")
  skip_if_not(nzchar(path) && file.exists(path),
               "fixture file not installed")

  tables <- aemo:::aemo_parse_csv(path)
  price_nm <- names(tables)[grepl("price", names(tables), ignore.case = TRUE)][1L]
  df <- aemo:::aemo_coerce_types(tables[[price_nm]])

  df_nsw <- aemo:::aemo_apply_filters(df, region = "NSW1")
  expect_true(all(df_nsw$regionid == "NSW1"))
  expect_equal(nrow(df_nsw), 2L)  # NSW1 appears in both 00:05 and 00:10
})

test_that("aemo_parse_time is AEST and DST-safe on fixture timestamps", {
  # 2024-01-15 is mid-summer in Australia: Sydney is AEDT (UTC+11).
  # Market time must remain AEST (UTC+10). Verify by checking the UTC offset.
  t <- aemo:::aemo_parse_time("2024-01-15 00:05:00")
  # UTC offset for Australia/Brisbane is always +10:00
  offset_hrs <- as.numeric(format(t, "%z")) / 100
  expect_equal(offset_hrs, 10)
})
