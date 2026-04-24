# Schema drift tests: verify that parsing two DISPATCHPRICE fixtures
# with different column sets (pre-5MS v4 without RAISE1SEC* columns,
# and v5 post-9 Oct 2023 with them) stacks correctly on the common
# intersection.

fixture_path <- function(name) {
  system.file("testdata", name, package = "aemo")
}

test_that("v4 (pre-5MS) DISPATCHPRICE fixture parses with reduced column set", {
  path <- fixture_path("PUBLIC_DISPATCHIS_202101150000_V4_FIXTURE.CSV")
  skip_if_not(nzchar(path) && file.exists(path),
               "v4 fixture not installed")

  tables <- aemo:::aemo_parse_csv(path)
  expect_true("dispatch_price" %in% names(tables))
  df <- aemo:::aemo_coerce_types(tables$dispatch_price)

  # v4 has 8 FCAS RRP services (no RAISE1SEC / LOWER1SEC)
  expect_false("raise1secrrp" %in% names(df))
  expect_false("lower1secrrp" %in% names(df))
  expect_true("raise6secrrp" %in% names(df))
  expect_equal(nrow(df), 5L)

  # NSW1 at 00:05 on 15-Jan-2021: 45.10 AUD/MWh
  nsw <- df[df$regionid == "NSW1", ]
  expect_equal(nrow(nsw), 1L)
  expect_equal(nsw$rrp, 45.10)
})

test_that("v4 and v5 DISPATCHPRICE fixtures stack on common intersection", {
  v4 <- fixture_path("PUBLIC_DISPATCHIS_202101150000_V4_FIXTURE.CSV")
  v5 <- fixture_path("PUBLIC_DISPATCHIS_202401150000_FIXTURE.CSV")
  skip_if_not(nzchar(v4) && file.exists(v4) &&
                nzchar(v5) && file.exists(v5),
               "fixtures not installed")

  df4 <- aemo:::aemo_coerce_types(aemo:::aemo_parse_csv(v4)$dispatch_price)
  df5 <- aemo:::aemo_coerce_types(aemo:::aemo_parse_csv(v5)$dispatch_price)

  # Intersection of columns
  common <- intersect(names(df4), names(df5))
  # The common set must include the canonical analytical columns
  expect_true(all(c("settlementdate", "regionid", "rrp",
                    "raise6secrrp", "lower6secrrp") %in% common))
  # But must NOT include v5-only additions
  expect_false("raise1secrrp" %in% common)
  expect_false("bestdispatchintervalselection" %in% common)

  # Stack and confirm row counts and RRPs are preserved
  stacked <- rbind(df4[, common, drop = FALSE], df5[, common, drop = FALSE])
  expect_equal(nrow(stacked), nrow(df4) + nrow(df5))
  expect_true(is.numeric(stacked$rrp))
  # All timestamps in AEST
  expect_equal(attr(stacked$settlementdate, "tzone"), "Australia/Brisbane")
})
