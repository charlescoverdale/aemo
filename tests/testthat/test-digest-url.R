test_that("aemo_digest_url is deterministic and 16 hex characters", {
  a <- aemo:::aemo_digest_url("http://nemweb.com.au/Reports/Current/DispatchIS/x.zip")
  b <- aemo:::aemo_digest_url("http://nemweb.com.au/Reports/Current/DispatchIS/x.zip")
  expect_equal(a, b)
  expect_match(a, "^[0-9a-f]{16}$")
})

test_that("aemo_digest_url avoids trivial collisions", {
  a <- aemo:::aemo_digest_url("http://nemweb.com.au/a.zip")
  b <- aemo:::aemo_digest_url("http://nemweb.com.au/b.zip")
  expect_false(identical(a, b))

  # Anagrams must not collide (v0.1.0's weighted checksum could)
  c1 <- aemo:::aemo_digest_url("http://x/AB.zip")
  c2 <- aemo:::aemo_digest_url("http://x/BA.zip")
  expect_false(identical(c1, c2))
})
