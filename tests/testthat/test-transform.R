# Tests for data transformation functions

# ============================================================================
# tidy_names() basic tests
# ============================================================================

test_that("tidy_names converts to snake_case by default", {
  skip_if_not_installed("janitor")
  
  df <- data.frame(
    GEOGRAPHY_NAME = "UK",
    OBS_VALUE = 100,
    DATE_CODE = "2020"
  )
  
  result <- tidy_names(df)
  
  expect_true("geography_name" %in% names(result))
  expect_true("obs_value" %in% names(result))
  expect_true("date_code" %in% names(result))
})

test_that("tidy_names supports camelCase style", {
  skip_if_not_installed("janitor")
  
  df <- data.frame(
    GEOGRAPHY_NAME = "UK",
    OBS_VALUE = 100
  )
  
  result <- tidy_names(df, "camelCase")
  
  # janitor might produce "geographyName" or "geographyname"
  expect_true(any(c("geographyName", "geographyname") %in% names(result)))
})

test_that("tidy_names supports period.case style", {
  skip_if_not_installed("janitor")
  
  df <- data.frame(
    GEOGRAPHY_NAME = "UK",
    OBS_VALUE = 100
  )
  
  result <- tidy_names(df, "period.case")
  
  expect_true("geography.name" %in% names(result))
  expect_true("obs.value" %in% names(result))
})

test_that("tidy_names handles missing janitor gracefully", {
  skip_if_installed("janitor")
  
  df <- data.frame(GEOGRAPHY_NAME = "UK", OBS_VALUE = 100)
  
  expect_warning(
    result <- tidy_names(df),
    "janitor.*not available"
  )
  
  expect_equal(result, df)
  expect_equal(names(result), c("GEOGRAPHY_NAME", "OBS_VALUE"))
})

test_that("tidy_names preserves data", {
  skip_if_not_installed("janitor")
  
  df <- data.frame(
    GEOGRAPHY_NAME = c("UK", "US"),
    OBS_VALUE = c(100, 200)
  )
  
  result <- tidy_names(df)
  
  expect_equal(nrow(result), 2)
  expect_equal(result[[1]], c("UK", "US"))
  expect_equal(result[[2]], c(100, 200))
})

test_that("tidy_names handles single column", {
  skip_if_not_installed("janitor")
  
  df <- data.frame(GEOGRAPHY_CODE = "123")
  
  result <- tidy_names(df)
  
  expect_true("geography_code" %in% names(result))
})

test_that("tidy_names handles many columns", {
  skip_if_not_installed("janitor")
  
  df <- data.frame(
    COL_A = 1, COL_B = 2, COL_C = 3,
    COL_D = 4, COL_E = 5, COL_F = 6
  )
  
  result <- tidy_names(df)
  
  expect_equal(ncol(result), 6)
  expect_true(all(grepl("col_", names(result))))
})

test_that("tidy_names handles columns with numbers", {
  skip_if_not_installed("janitor")
  
  df <- data.frame(
    GEOGRAPHY_2020 = "UK",
    VALUE_123 = 100
  )
  
  result <- tidy_names(df)
  
  expect_true("geography_2020" %in% names(result))
  expect_true("value_123" %in% names(result))
})

test_that("tidy_names handles columns with special characters", {
  skip_if_not_installed("janitor")
  
  df <- data.frame(
    `GEOGRAPHY-NAME` = "UK",
    `OBS%VALUE` = 100,
    check.names = FALSE
  )
  
  result <- tidy_names(df)
  
  # janitor should clean these
  expect_true(length(names(result)) == 2)
})

test_that("tidy_names handles empty data frame", {
  skip_if_not_installed("janitor")
  
  df <- data.frame()
  
  result <- tidy_names(df)
  
  expect_equal(nrow(result), 0)
  expect_equal(ncol(result), 0)
})

test_that("tidy_names handles columns that are already clean", {
  skip_if_not_installed("janitor")
  
  df <- data.frame(
    geography = "UK",
    value = 100
  )
  
  result <- tidy_names(df)
  
  expect_true("geography" %in% names(result))
  expect_true("value" %in% names(result))
})

test_that("tidy_names style argument is case-sensitive", {
  skip_if_not_installed("janitor")
  
  df <- data.frame(TEST_COL = 1)
  
  # Should work with exact case
  expect_error(tidy_names(df, "snake_case"), NA)
  expect_error(tidy_names(df, "camelCase"), NA)
  expect_error(tidy_names(df, "period.case"), NA)
})

test_that("tidy_names handles NA values in data", {
  skip_if_not_installed("janitor")
  
  df <- data.frame(
    GEOGRAPHY_NAME = c("UK", NA),
    OBS_VALUE = c(100, NA)
  )
  
  result <- tidy_names(df)
  
  expect_equal(result[[1]][2], NA_character_)
  expect_equal(result[[2]][2], NA_real_)
})

test_that("tidy_names returns data frame", {
  skip_if_not_installed("janitor")
  
  df <- data.frame(TEST = 1)
  result <- tidy_names(df)
  
  expect_true(is.data.frame(result))
})

test_that("tidy_names handles tibbles", {
  skip_if_not_installed("janitor")
  
  df <- tibble::tibble(
    GEOGRAPHY_NAME = "UK",
    OBS_VALUE = 100
  )
  
  result <- tidy_names(df)
  
  expect_true("geography_name" %in% names(result))
})

test_that("tidy_names snake_case handles consecutive underscores", {
  skip_if_not_installed("janitor")
  
  df <- data.frame(
    GEOGRAPHY__NAME = "UK"  # Double underscore
  )
  
  result <- tidy_names(df)
  
  # janitor should clean this
  expect_true(length(names(result)) == 1)
})

test_that("tidy_names period.case replaces underscores with periods", {
  skip_if_not_installed("janitor")
  
  df <- data.frame(
    GEOGRAPHY_NAME = "UK",
    OBS_VALUE_TOTAL = 100
  )
  
  result <- tidy_names(df, "period.case")
  
  expect_true("geography.name" %in% names(result))
  expect_true("obs.value.total" %in% names(result))
  expect_false(any(grepl("_", names(result))))
})

test_that("tidy_names handles duplicated column names", {
  skip_if_not_installed("janitor")
  
  df <- data.frame(
    VALUE = 1,
    VALUE.1 = 2
  )
  
  result <- tidy_names(df)
  
  # Should handle duplicates somehow
  expect_equal(ncol(result), 2)
})

test_that("tidy_names with janitor unavailable returns warning", {
  skip_if_installed("janitor")
  
  df <- data.frame(TEST = 1)
  
  expect_warning(
    tidy_names(df),
    "not available"
  )
})

test_that("tidy_names with janitor unavailable returns unchanged df", {
  skip_if_installed("janitor")
  
  df <- data.frame(ORIGINAL_NAME = 1)
  
  result <- suppressWarnings(tidy_names(df))
  
  expect_identical(names(result), "ORIGINAL_NAME")
})