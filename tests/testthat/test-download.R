# Tests for main data download function

test_that("fetch_nomis requires dataset ID", {
  expect_error(
    fetch_nomis(),
    "Dataset ID required"
  )
})

test_that("fetch_nomis builds correct parameters", {
  skip_if_no_api()
  skip_on_cran()
  
  result <- fetch_nomis(
    "NM_1_1",
    time = "latest",
    geography = "TYPE499",
    sex = 7,
    measures = 20100
  )
  
  expect_s3_class(result, "tbl_df")
  expect_true("OBS_VALUE" %in% names(result))
  expect_true(nrow(result) > 0)
})

test_that("fetch_nomis handles date parameter", {
  skip_if_no_api()
  skip_on_cran()
  
  result <- fetch_nomis(
    "NM_1_1",
    date = "latest",
    geography = "TYPE499",
    measures = 20100
  )
  
  expect_s3_class(result, "tbl_df")
})

test_that("fetch_nomis handles multiple geographies", {
  skip_if_no_api()
  skip_on_cran()
  
  result <- fetch_nomis(
    "NM_1_1",
    time = "latest",
    geography = c("2092957697", "2092957698"),
    measures = 20100
  )
  
  expect_true(nrow(result) >= 2)
})

test_that("fetch_nomis respects select parameter", {
  skip_if_no_api()
  skip_on_cran()
  
  result <- fetch_nomis(
    "NM_1_1",
    time = "latest",
    geography = "TYPE499",
    measures = 20100,
    select = c("GEOGRAPHY_CODE", "OBS_VALUE")
  )
  
  # Should have at least these columns (may have RECORD_COUNT)
  expect_true("GEOGRAPHY_CODE" %in% names(result))
  expect_true("OBS_VALUE" %in% names(result))
})

test_that("fetch_nomis handles exclude_missing", {
  skip_if_no_api()
  skip_on_cran()
  
  result <- fetch_nomis(
    "NM_1_1",
    time = "latest",
    geography = "TYPE499",
    measures = 20100,
    exclude_missing = TRUE
  )
  
  expect_s3_class(result, "tbl_df")
})

test_that("build_params creates correct parameter list", {
  params <- build_params(
    id = "NM_1_1",
    time = "latest",
    date = NULL,
    geography = "TYPE499",
    sex = 7,
    measures = c(20100, 20201),
    exclude_missing = TRUE,
    select = c("GEOGRAPHY_CODE", "OBS_VALUE")
  )
  
  expect_equal(params$time, "latest")
  expect_equal(params$geography, "TYPE499")
  expect_equal(params$sex, "7")
  expect_equal(params$MEASURES, "20100,20201")
  expect_equal(params$ExcludeMissingValues, "true")
  expect_match(params$select, "GEOGRAPHY_CODE")
  expect_match(params$select, "RECORD_COUNT")
})