# Tests for aggregation functions

test_that("aggregate_geography validates value column", {
  df <- data.frame(
    GEOGRAPHY_CODE = "123",
    VALUE = 100
  )
  
  expect_error(
    aggregate_geography(df, "TYPE499", "OBS_VALUE"),
    "Column.*not found"
  )
})

test_that("aggregate_geography aggregates data", {
  df <- data.frame(
    GEOGRAPHY_CODE = c("123", "123", "456"),
    GEOGRAPHY_NAME = c("Area A", "Area A", "Area B"),
    CATEGORY = c("X", "X", "Y"),
    OBS_VALUE = c(10, 20, 30)
  )
  
  result <- aggregate_geography(df, "TYPE499", "OBS_VALUE")
  
  expect_s3_class(result, "data.frame")
  expect_equal(nrow(result), 2)  # Two categories
})

test_that("aggregate_time requires DATE column", {
  df <- data.frame(OBS_VALUE = c(1, 2, 3))
  
  expect_error(
    aggregate_time(df),
    "must contain.*DATE"
  )
})

test_that("aggregate_time aggregates by period", {
  df <- data.frame(
    DATE = c("2020-01", "2020-02", "2021-01"),
    DATE_NAME = c("Jan 2020", "Feb 2020", "Jan 2021"),
    CATEGORY = c("A", "A", "B"),
    OBS_VALUE = c(10, 20, 30)
  )
  
  result <- aggregate_time(df, "year", "OBS_VALUE", mean)
  
  expect_s3_class(result, "data.frame")
  expect_true("PERIOD" %in% names(result))
  expect_equal(length(unique(result$PERIOD)), 2)
})