test_that("add_geography_names requires GEOGRAPHY_CODE", {
  df <- data.frame(VALUE = 1)
  expect_error(add_geography_names(df), "GEOGRAPHY_CODE")
})

test_that("add_geography_names returns data when name exists", {
  df <- data.frame(GEOGRAPHY_CODE = "1", GEOGRAPHY_NAME = "Test")
  result <- suppressMessages(add_geography_names(df))
  expect_identical(result, df)
})