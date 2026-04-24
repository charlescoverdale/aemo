test_that("aemo_snapshot returns one row per aemo_tbl with expected columns", {
  x <- structure(
    data.frame(settlementdate = as.POSIXct("2024-06-01", tz = "Australia/Brisbane"),
               regionid = "NSW1", rrp = 80.5),
    aemo_title = "Test",
    aemo_source = "http://nemweb.com.au",
    aemo_licence = "AEMO Copyright Permissions Notice",
    aemo_retrieved = as.POSIXct("2024-06-01 12:00:00", tz = "Australia/Brisbane"),
    class = c("aemo_tbl", "data.frame")
  )

  snap <- aemo_snapshot(x)
  expect_s3_class(snap, "data.frame")
  expect_equal(nrow(snap), 1L)
  expect_true(all(c("title", "source", "licence", "retrieved",
                    "rows", "cols", "sha256") %in% names(snap)))
  expect_equal(snap$title, "Test")
  expect_equal(snap$source, "http://nemweb.com.au")
  expect_equal(snap$rows, 1L)
  expect_equal(snap$cols, 3L)
  # SHA-256 is hex, 64 chars
  expect_match(snap$sha256, "^[0-9a-f]{64}$")
})

test_that("aemo_snapshot is deterministic for identical data", {
  make <- function() {
    structure(
      data.frame(x = 1:3, y = letters[1:3]),
      aemo_title = "T",
      aemo_source = "s",
      aemo_licence = "l",
      aemo_retrieved = as.POSIXct("2024-01-01", tz = "UTC"),
      class = c("aemo_tbl", "data.frame")
    )
  }
  expect_equal(aemo_snapshot(make())$sha256, aemo_snapshot(make())$sha256)
})

test_that("aemo_snapshot detects any row change", {
  a <- structure(data.frame(x = 1:3), aemo_title = "T",
                 class = c("aemo_tbl", "data.frame"))
  b <- structure(data.frame(x = c(1:2, 4L)), aemo_title = "T",
                 class = c("aemo_tbl", "data.frame"))
  expect_false(identical(aemo_snapshot(a)$sha256,
                         aemo_snapshot(b)$sha256))
})

test_that("aemo_snapshot accepts a list of aemo_tbls", {
  mk <- function(n) structure(data.frame(x = seq_len(n)),
                              aemo_title = paste("T", n),
                              class = c("aemo_tbl", "data.frame"))
  snap <- aemo_snapshot(list(mk(1L), mk(2L)))
  expect_equal(nrow(snap), 2L)
  expect_equal(snap$rows, c(1L, 2L))
})
