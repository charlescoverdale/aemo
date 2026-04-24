test_that("aemo_settlement validates table argument", {
  expect_error(aemo_settlement(table = "invalid",
                                start = "2024-06-01",
                                end   = "2024-06-02"))
})

test_that("aemo_settlement requires start <= end", {
  expect_error(
    aemo_settlement(start = "2024-06-02 00:00:00",
                     end   = "2024-06-01 00:00:00"),
    class = "simpleError"
  )
})
