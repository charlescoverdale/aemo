test_that("aemo_price_caps has expected shape and source_doc column", {
  caps <- aemo_price_caps()
  expect_s3_class(caps, "aemo_tbl")
  expect_true(all(c("year", "market_price_cap_aud_per_mwh",
                    "market_price_floor_aud_per_mwh",
                    "cumulative_price_threshold_aud",
                    "administered_price_cap_aud_per_mwh",
                    "source_doc") %in% names(caps)))
  # Post-June-2022 CPT step change is the headline data point
  v2022 <- caps[caps$year == "2022-23", ]
  expect_equal(v2022$cumulative_price_threshold_aud, 1398100)
  expect_match(v2022$source_doc, "AEMC 2022")
  # Every row has a source
  expect_true(all(nzchar(caps$source_doc)))
})
