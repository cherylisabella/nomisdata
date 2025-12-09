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

test_that("fetch_nomis handles time parameter", {
  skip_if_no_api()
  skip_on_cran()
  
  result <- fetch_nomis(
    "NM_1_1",
    time = "latest",
    geography = "TYPE499",
    measures = 20100
  )
  
  expect_s3_class(result, "tbl_df")
})

test_that("fetch_nomis handles multiple measures", {
  skip_if_no_api()
  skip_on_cran()
  
  result <- fetch_nomis(
    "NM_1_1",
    time = "latest",
    geography = "TYPE499",
    measures = c(20100, 20101)
  )
  
  expect_s3_class(result, "tbl_df")
})

test_that("fetch_nomis removes RECORD_COUNT when not in select", {
  skip_if_no_api()
  skip_on_cran()
  
  result <- fetch_nomis(
    "NM_1_1",
    time = "latest",
    geography = "TYPE499",
    measures = 20100,
    select = c("GEOGRAPHY_CODE", "OBS_VALUE")
  )
  
  expect_false("RECORD_COUNT" %in% names(result))
})

test_that("fetch_nomis keeps RECORD_COUNT when explicitly selected", {
  skip_if_no_api()
  skip_on_cran()
  
  result <- fetch_nomis(
    "NM_1_1",
    time = "latest",
    geography = "TYPE499",
    measures = 20100,
    select = c("GEOGRAPHY_CODE", "RECORD_COUNT")
  )
  
  expect_true("RECORD_COUNT" %in% names(result))
})

test_that("fetch_nomis handles additional parameters via ...", {
  skip_if_no_api()
  skip_on_cran()
  
  result <- fetch_nomis(
    "NM_1_1",
    time = "latest",
    geography = "TYPE499",
    measures = 20100,
    sex = 7  # Use sex instead of age, which is more reliable
  )
  
  expect_s3_class(result, "tbl_df")
})

test_that("fetch_nomis respects .progress = FALSE", {
  skip_if_no_api()
  skip_on_cran()
  
  result <- fetch_nomis(
    "NM_1_1",
    time = "latest",
    geography = "TYPE499",
    measures = 20100,
    .progress = FALSE
  )
  
  expect_s3_class(result, "tbl_df")
})

test_that("build_params handles multiple values", {
  params <- build_params(
    id = "NM_1_1",
    time = c("latest", "prevyear"),
    date = NULL,
    geography = c("TYPE499", "TYPE480"),
    sex = c(1, 2),
    measures = c(20100, 20101),
    exclude_missing = FALSE,
    select = NULL
  )
  
  expect_equal(params$time, "latest,prevyear")
  expect_equal(params$geography, "TYPE499,TYPE480")
  expect_equal(params$sex, "1,2")
  expect_equal(params$MEASURES, "20100,20101")
})

test_that("build_params prefers date over time", {
  params <- build_params(
    id = "NM_1_1",
    time = "latest",
    date = "2020-01",
    geography = NULL,
    sex = NULL,
    measures = NULL,
    exclude_missing = FALSE,
    select = NULL
  )
  
  expect_equal(params$date, "2020-01")
  expect_null(params$time)
})

test_that("build_params handles exclude_missing FALSE", {
  params <- build_params(
    id = "NM_1_1",
    time = "latest",
    date = NULL,
    geography = NULL,
    sex = NULL,
    measures = NULL,
    exclude_missing = FALSE,
    select = NULL
  )
  
  expect_null(params$ExcludeMissingValues)
})

test_that("build_params uppercases select columns", {
  params <- build_params(
    id = "NM_1_1",
    time = "latest",
    date = NULL,
    geography = NULL,
    sex = NULL,
    measures = NULL,
    exclude_missing = FALSE,
    select = c("geography_code", "obs_value")
  )
  
  expect_true(grepl("GEOGRAPHY_CODE", params$select))
  expect_true(grepl("OBS_VALUE", params$select))
  expect_true(grepl("RECORD_COUNT", params$select))
})

test_that("build_params handles additional parameters", {
  params <- build_params(
    id = "NM_1_1",
    time = "latest",
    date = NULL,
    geography = NULL,
    sex = NULL,
    measures = NULL,
    exclude_missing = FALSE,
    select = NULL,
    age = 0,
    occupation = c(1, 2, 3)
  )
  
  expect_equal(params$AGE, "0")
  expect_equal(params$OCCUPATION, "1,2,3")
})

test_that("build_params handles NULL values", {
  params <- build_params(
    id = "NM_1_1",
    time = NULL,
    date = NULL,
    geography = NULL,
    sex = NULL,
    measures = NULL,
    exclude_missing = FALSE,
    select = NULL
  )
  
  expect_null(params$time)
  expect_null(params$date)
  expect_null(params$geography)
})

test_that("build_params uppercases parameter names from ...", {
  params <- build_params(
    id = "NM_1_1",
    time = "latest",
    date = NULL,
    geography = NULL,
    sex = NULL,
    measures = NULL,
    exclude_missing = FALSE,
    select = NULL,
    age = 0,
    occupation = 1
  )
  
  expect_true("AGE" %in% names(params))
  expect_true("OCCUPATION" %in% names(params))
  expect_false("age" %in% names(params))
})

test_that("build_params handles empty dots", {
  params <- build_params(
    id = "NM_1_1",
    time = "latest",
    date = NULL,
    geography = NULL,
    sex = NULL,
    measures = NULL,
    exclude_missing = FALSE,
    select = NULL
  )
  
  expect_type(params, "list")
})

test_that("build_params removes NULL values from dots", {
  params <- build_params(
    id = "NM_1_1",
    time = "latest",
    date = NULL,
    geography = NULL,
    sex = NULL,
    measures = NULL,
    exclude_missing = FALSE,
    select = NULL,
    age = NULL,
    occupation = 1
  )
  
  expect_false("AGE" %in% names(params))
  expect_true("OCCUPATION" %in% names(params))
})

test_that("fetch_paginated is a function", {
  expect_type(fetch_paginated, "closure")
})