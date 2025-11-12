# Tests for data transformation functions

test_that("tidy_names converts to snake_case by default", {
  skip_if_not_installed("janitor")
  
  df <- data.frame(
    GEOGRAPHY_NAME = "UK",
    OBS_VALUE = 100
  )
  
  result <- tidy_names(df)
  
  expect_true("geography_name" %in% names(result))
  expect_true("obs_value" %in% names(result))
})

test_that("tidy_names supports different styles", {
  skip_if_not_installed("janitor")
  
  df <- data.frame(
    GEOGRAPHY_NAME = "UK",
    OBS_VALUE = 100
  )
  
  result_camel <- tidy_names(df, "camelCase")
  expect_true("geographyName" %in% names(result_camel) || 
                "geographyname" %in% names(result_camel))
  
  result_period <- tidy_names(df, "period.case")
  expect_true("geography.name" %in% names(result_period))
})

test_that("tidy_names handles missing janitor gracefully", {
  # Test the opposite - when janitor is NOT installed
  if (requireNamespace("janitor", quietly = TRUE)) {
    skip("janitor is installed, cannot test fallback behavior")
  }
  
  df <- data.frame(GEOGRAPHY_NAME = "UK")
  
  expect_warning(
    result <- tidy_names(df),
    "janitor.*not available"
  )
  
  expect_equal(result, df)
})
