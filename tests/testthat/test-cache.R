test_that("aemo_cache_dir honours the aemo.cache_dir option", {
  tmp <- tempfile("aemo_cache_")
  op <- options(aemo.cache_dir = tmp)
  on.exit(options(op), add = TRUE)
  d <- aemo:::aemo_cache_dir()
  expect_equal(normalizePath(d), normalizePath(tmp))
})

test_that("aemo_cache_info returns expected structure", {
  tmp <- tempfile("aemo_cache_")
  op <- options(aemo.cache_dir = tmp)
  on.exit(options(op), add = TRUE)
  info <- aemo_cache_info()
  expect_setequal(names(info), c("dir", "n_files", "size_bytes", "size_human", "files"))
  expect_equal(info$n_files, 0L)
})

test_that("aemo_cache_info counts files", {
  tmp <- tempfile("aemo_cache_")
  op <- options(aemo.cache_dir = tmp)
  on.exit(options(op), add = TRUE)
  dir.create(tmp, recursive = TRUE)
  writeLines("a", file.path(tmp, "a.zip"))
  info <- aemo_cache_info()
  expect_equal(info$n_files, 1L)
})

test_that("aemo_clear_cache removes files", {
  tmp <- tempfile("aemo_cache_")
  op <- options(aemo.cache_dir = tmp)
  on.exit(options(op), add = TRUE)
  dir.create(tmp, recursive = TRUE)
  writeLines("x", file.path(tmp, "x.zip"))
  expect_invisible(aemo_clear_cache())
  expect_false(file.exists(file.path(tmp, "x.zip")))
})

test_that("aemo_throttle validates and round-trips", {
  old <- aemo_throttle(0.5)
  expect_equal(getOption("aemo.throttle_delay"), 0.5)
  aemo_throttle(old)
  expect_equal(getOption("aemo.throttle_delay"), old)
  expect_error(aemo_throttle(-1))
  expect_error(aemo_throttle("fast"))
})

test_that("aemo_format_bytes formats thresholds", {
  expect_equal(aemo:::aemo_format_bytes(0), "0 B")
  expect_match(aemo:::aemo_format_bytes(1500), "KB$")
  expect_match(aemo:::aemo_format_bytes(1500000), "MB$")
})
