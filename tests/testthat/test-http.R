test_that("aemo_digest_url is deterministic", {
  a <- aemo:::aemo_digest_url("http://nemweb.com.au/a")
  b <- aemo:::aemo_digest_url("http://nemweb.com.au/a")
  c <- aemo:::aemo_digest_url("http://nemweb.com.au/b")
  expect_equal(a, b)
  expect_false(identical(a, c))
})

test_that("aemo_user_agent includes package version", {
  ua <- aemo:::aemo_user_agent()
  expect_match(ua, "^aemo R package/")
})

test_that("aemo_base_url honours option", {
  op <- options(aemo.base_url = "http://example.com")
  on.exit(options(op), add = TRUE)
  expect_equal(aemo:::aemo_base_url(), "http://example.com")
})

test_that("aemo_request returns httr2_request", {
  req <- aemo:::aemo_request("http://nemweb.com.au")
  expect_s3_class(req, "httr2_request")
})
