# Tests for aggregation functions

# ============================================================================
# aggregate_geography() tests
# ============================================================================

test_that("aggregate_geography validates value column exists", {
  df <- data.frame(
    GEOGRAPHY_CODE = "123",
    VALUE = 100
  )
  
  expect_error(
    aggregate_geography(df, "TYPE499", "OBS_VALUE"),
    "Column.*not found"
  )
})

test_that("aggregate_geography aggregates data correctly", {
  df <- data.frame(
    GEOGRAPHY_CODE = c("123", "123", "456"),
    GEOGRAPHY_NAME = c("Area A", "Area A", "Area B"),
    CATEGORY = c("X", "X", "Y"),
    OBS_VALUE = c(10, 20, 30)
  )
  
  result <- aggregate_geography(df, "TYPE499", "OBS_VALUE")
  
  expect_s3_class(result, "data.frame")
  expect_equal(nrow(result), 2)
})

test_that("aggregate_geography uses sum by default", {
  df <- data.frame(
    GEOGRAPHY_CODE = c("123", "123"),
    CATEGORY = c("X", "X"),
    OBS_VALUE = c(10, 20)
  )
  
  result <- aggregate_geography(df, "TYPE499", "OBS_VALUE", sum)
  
  expect_equal(result$OBS_VALUE[1], 30)
})

test_that("aggregate_geography accepts custom aggregation function", {
  df <- data.frame(
    GEOGRAPHY_CODE = c("123", "123"),
    CATEGORY = c("X", "X"),
    OBS_VALUE = c(10, 20)
  )
  
  result <- aggregate_geography(df, "TYPE499", "OBS_VALUE", mean)
  
  expect_equal(result$OBS_VALUE[1], 15)
})

test_that("aggregate_geography handles NA values with na.rm=TRUE", {
  df <- data.frame(
    GEOGRAPHY_CODE = c("123", "123"),
    CATEGORY = c("X", "X"),
    OBS_VALUE = c(10, NA)
  )
  
  result <- aggregate_geography(df, "TYPE499", "OBS_VALUE", sum)
  
  expect_equal(result$OBS_VALUE[1], 10)
})

test_that("aggregate_geography removes geography columns from grouping", {
  df <- data.frame(
    GEOGRAPHY_CODE = c("123", "123"),
    GEOGRAPHY_NAME = c("Area", "Area"),
    CATEGORY = c("X", "X"),
    OBS_VALUE = c(10, 20)
  )
  
  result <- aggregate_geography(df, "TYPE499", "OBS_VALUE")
  
  expect_equal(nrow(result), 1)
})

test_that("aggregate_geography removes RECORD_COUNT from grouping", {
  df <- data.frame(
    GEOGRAPHY_CODE = "123",
    RECORD_COUNT = 1,
    CATEGORY = "X",
    OBS_VALUE = 100
  )
  
  result <- aggregate_geography(df, "TYPE499", "OBS_VALUE")
  
  expect_false("RECORD_COUNT" %in% names(result))
})

test_that("aggregate_geography handles single row", {
  df <- data.frame(
    GEOGRAPHY_CODE = "123",
    OBS_VALUE = 100
  )
  
  result <- aggregate_geography(df, "TYPE499", "OBS_VALUE")
  
  expect_equal(nrow(result), 1)
  expect_equal(result$OBS_VALUE[1], 100)
})

test_that("aggregate_geography handles multiple grouping variables", {
  df <- data.frame(
    GEOGRAPHY_CODE = c("123", "123", "123"),
    CAT1 = c("A", "A", "B"),
    CAT2 = c("X", "Y", "X"),
    OBS_VALUE = c(10, 20, 30)
  )
  
  result <- aggregate_geography(df, "TYPE499", "OBS_VALUE")
  
  expect_equal(nrow(result), 3)
})

test_that("aggregate_geography preserves non-value columns", {
  df <- data.frame(
    GEOGRAPHY_CODE = c("123", "123"),
    CATEGORY = c("X", "X"),
    DATE = c("2020", "2020"),
    OBS_VALUE = c(10, 20)
  )
  
  result <- aggregate_geography(df, "TYPE499", "OBS_VALUE")
  
  expect_true("CATEGORY" %in% names(result))
  expect_true("DATE" %in% names(result))
})

# ============================================================================
# aggregate_time() tests
# ============================================================================

test_that("aggregate_time requires DATE column", {
  df <- data.frame(OBS_VALUE = c(1, 2, 3))
  
  expect_error(
    aggregate_time(df),
    "must contain.*DATE"
  )
})

test_that("aggregate_time aggregates by year", {
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

test_that("aggregate_time uses mean by default", {
  df <- data.frame(
    DATE = c("2020-01", "2020-02"),
    CATEGORY = "A",
    OBS_VALUE = c(10, 20)
  )
  
  result <- aggregate_time(df, "year", "OBS_VALUE", mean)
  
  expect_equal(result$OBS_VALUE[1], 15)
})

test_that("aggregate_time accepts custom aggregation function", {
  df <- data.frame(
    DATE = c("2020-01", "2020-02"),
    CATEGORY = "A",
    OBS_VALUE = c(10, 20)
  )
  
  result <- aggregate_time(df, "year", "OBS_VALUE", sum)
  
  expect_equal(result$OBS_VALUE[1], 30)
})

test_that("aggregate_time extracts year from DATE", {
  df <- data.frame(
    DATE = c("2020-01", "2020-02", "2021-01"),
    OBS_VALUE = c(10, 20, 30)
  )
  
  result <- aggregate_time(df, "year", "OBS_VALUE")
  
  expect_true("2020" %in% result$PERIOD)
  expect_true("2021" %in% result$PERIOD)
})

test_that("aggregate_time removes DATE columns from grouping", {
  df <- data.frame(
    DATE = c("2020-01", "2020-02"),
    DATE_NAME = c("Jan", "Feb"),
    CATEGORY = "A",
    OBS_VALUE = c(10, 20)
  )
  
  result <- aggregate_time(df, "year", "OBS_VALUE")
  
  expect_false("DATE" %in% names(result))
  expect_false("DATE_NAME" %in% names(result))
})

test_that("aggregate_time removes RECORD_COUNT from grouping", {
  df <- data.frame(
    DATE = "2020-01",
    RECORD_COUNT = 1,
    OBS_VALUE = 100
  )
  
  result <- aggregate_time(df, "year", "OBS_VALUE")
  
  expect_false("RECORD_COUNT" %in% names(result))
})

test_that("aggregate_time handles single time period", {
  df <- data.frame(
    DATE = c("2020-01", "2020-02"),
    OBS_VALUE = c(10, 20)
  )
  
  result <- aggregate_time(df, "year", "OBS_VALUE")
  
  expect_equal(nrow(result), 1)
  expect_equal(result$PERIOD[1], "2020")
})

test_that("aggregate_time handles multiple categories", {
  df <- data.frame(
    DATE = c("2020-01", "2020-02", "2020-01", "2020-02"),
    CATEGORY = c("A", "A", "B", "B"),
    OBS_VALUE = c(10, 20, 30, 40)
  )
  
  result <- aggregate_time(df, "year", "OBS_VALUE", mean)
  
  expect_equal(nrow(result), 2)
})

test_that("aggregate_time handles NA values", {
  df <- data.frame(
    DATE = c("2020-01", "2020-02"),
    OBS_VALUE = c(10, NA)
  )
  
  result <- aggregate_time(df, "year", "OBS_VALUE", mean)
  
  expect_equal(result$OBS_VALUE[1], 10)
})

test_that("aggregate_time validates period argument", {
  df <- data.frame(
    DATE = "2020-01",
    OBS_VALUE = 100
  )
  
  expect_error(
    aggregate_time(df, "invalid", "OBS_VALUE"),
    "should be one of"
  )
})

test_that("aggregate_time accepts year period", {
  df <- data.frame(
    DATE = "2020-01",
    OBS_VALUE = 100
  )
  
  expect_error(
    aggregate_time(df, "year", "OBS_VALUE"),
    NA
  )
})

test_that("aggregate_time accepts quarter period", {
  df <- data.frame(
    DATE = "2020-01",
    OBS_VALUE = 100
  )
  
  expect_error(
    aggregate_time(df, "quarter", "OBS_VALUE"),
    NA
  )
})

test_that("aggregate_time accepts month period", {
  df <- data.frame(
    DATE = "2020-01",
    OBS_VALUE = 100
  )
  
  expect_error(
    aggregate_time(df, "month", "OBS_VALUE"),
    NA
  )
})

test_that("aggregate_time preserves grouping variables", {
  df <- data.frame(
    DATE = c("2020-01", "2020-02"),
    CATEGORY = "A",
    REGION = "North",
    OBS_VALUE = c(10, 20)
  )
  
  result <- aggregate_time(df, "year", "OBS_VALUE")
  
  expect_true("CATEGORY" %in% names(result))
  expect_true("REGION" %in% names(result))
})

# ============================================================================
# Integration tests
# ============================================================================

test_that("aggregate_geography and aggregate_time work together", {
  df <- data.frame(
    GEOGRAPHY_CODE = c("123", "123", "456", "456"),
    DATE = c("2020-01", "2020-02", "2020-01", "2020-02"),
    CATEGORY = c("A", "A", "A", "A"),
    OBS_VALUE = c(10, 20, 30, 40)
  )
  
  result1 <- aggregate_geography(df, "TYPE499", "OBS_VALUE")
  result2 <- aggregate_time(result1, "year", "OBS_VALUE")
  
  expect_s3_class(result2, "data.frame")
  expect_true("PERIOD" %in% names(result2))
})

test_that("aggregate_time handles empty data frame", {
  df <- data.frame(
    DATE = character(),
    OBS_VALUE = numeric()
  )
  
  result <- aggregate_time(df, "year", "OBS_VALUE")
  
  expect_equal(nrow(result), 0)
})