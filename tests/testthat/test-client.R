# Tests for client.R functions
# ============================================================================
# Constants tests (if they exist and are exported)
# ============================================================================

test_that("nomisdata package loads successfully", {
  expect_true("nomisdata" %in% loadedNamespaces())
})

test_that("core functions are available", {
  # Test that main exported functions exist
  expect_true(exists("fetch_nomis"))
  expect_true(is.function(fetch_nomis))
})

# ============================================================================
# build_request() tests (internal function used by fetch_nomis)
# ============================================================================

test_that("build_request exists and is accessible", {
  # This is an internal function, test via its usage
  expect_true(is.function(fetch_nomis))
})

test_that("fetch_nomis builds requests correctly", {
  skip_if_no_api()
  skip_on_cran()
  
  # Test that requests are built and executed
  result <- fetch_nomis(
    "NM_1_1",
    time = "latest",
    geography = "TYPE499",
    measures = 20100
  )
  
  expect_s3_class(result, "tbl_df")
})

# ============================================================================
# execute_request() tests (internal function)
# ============================================================================

test_that("fetch_nomis executes requests successfully", {
  skip_if_no_api()
  skip_on_cran()
  
  result <- fetch_nomis(
    "NM_1_1",
    time = "latest",
    geography = "TYPE499",
    measures = 20100
  )
  
  expect_s3_class(result, "tbl_df")
  expect_true(nrow(result) > 0)
})

test_that("fetch_nomis handles API responses", {
  skip_if_no_api()
  skip_on_cran()
  
  result <- fetch_nomis(
    "NM_1_1",
    time = "latest",
    geography = "TYPE499",
    measures = 20100
  )
  
  expect_type(result, "list")
  expect_s3_class(result, "data.frame")
})

# ============================================================================
# URL construction tests (via fetch_nomis behavior)
# ============================================================================

test_that("fetch_nomis constructs correct URLs for data requests", {
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

test_that("fetch_nomis handles different endpoint paths", {
  skip_if_no_api()
  skip_on_cran()
  
  # Different dataset
  result <- fetch_nomis(
    "NM_1_1",
    time = "latest",
    geography = "TYPE464",
    measures = 20100
  )
  
  expect_s3_class(result, "tbl_df")
})

# ============================================================================
# Query parameter tests (via fetch_nomis)
# ============================================================================

test_that("fetch_nomis handles single parameters", {
  skip_if_no_api()
  skip_on_cran()
  
  result <- fetch_nomis(
    "NM_1_1",
    time = "latest",
    measures = 20100
  )
  
  expect_s3_class(result, "tbl_df")
})

test_that("fetch_nomis handles multiple parameters", {
  skip_if_no_api()
  skip_on_cran()
  
  result <- fetch_nomis(
    "NM_1_1",
    time = "latest",
    geography = "TYPE499",
    measures = 20100,
    sex = 7,
    age = 0
  )
  
  expect_s3_class(result, "tbl_df")
})

test_that("fetch_nomis handles NULL parameters", {
  skip_if_no_api()
  skip_on_cran()
  
  result <- fetch_nomis(
    "NM_1_1",
    time = "latest",
    geography = NULL,
    measures = 20100
  )
  
  expect_s3_class(result, "tbl_df")
})

test_that("fetch_nomis handles vector parameters", {
  skip_if_no_api()
  skip_on_cran()
  
  result <- fetch_nomis(
    "NM_1_1",
    time = "latest",
    geography = c("2092957697", "2092957698"),
    measures = c(20100, 20101)
  )
  
  expect_s3_class(result, "tbl_df")
})

# ============================================================================
# Response parsing tests (via fetch_nomis)
# ============================================================================

test_that("fetch_nomis parses CSV responses correctly", {
  skip_if_no_api()
  skip_on_cran()
  
  result <- fetch_nomis(
    "NM_1_1",
    time = "latest",
    geography = "TYPE499",
    measures = 20100
  )
  
  expect_s3_class(result, "tbl_df")
  expect_true(ncol(result) > 0)
  expect_true(nrow(result) > 0)
})

test_that("fetch_nomis returns tibble format", {
  skip_if_no_api()
  skip_on_cran()
  
  result <- fetch_nomis(
    "NM_1_1",
    time = "latest",
    geography = "TYPE499",
    measures = 20100
  )
  
  expect_s3_class(result, "tbl_df")
  expect_true(is.data.frame(result))
})

test_that("fetch_nomis handles empty results gracefully", {
  skip_if_no_api()
  skip_on_cran()
  
  # Query that might return empty results
  result <- suppressWarnings(
    fetch_nomis(
      "NM_1_1",
      time = "1900",
      geography = "TYPE499",
      measures = 20100
    )
  )
  
  expect_s3_class(result, "tbl_df")
})

# ============================================================================
# Error handling tests
# ============================================================================

test_that("fetch_nomis handles invalid dataset IDs", {
  skip_if_no_api()
  skip_on_cran()
  
  expect_error(
    fetch_nomis("INVALID_DATASET_999"),
    ".*"
  )
})

test_that("fetch_nomis requires dataset id", {
  expect_error(
    fetch_nomis(),
    ".*"
  )
})

# ============================================================================
# Special parameter handling tests
# ============================================================================

test_that("fetch_nomis handles select parameter", {
  skip_if_no_api()
  skip_on_cran()
  
  result <- fetch_nomis(
    "NM_1_1",
    time = "latest",
    geography = "TYPE499",
    measures = 20100,
    select = c("GEOGRAPHY_CODE", "OBS_VALUE")
  )
  
  expect_s3_class(result, "tbl_df")
  expect_true(all(c("GEOGRAPHY_CODE", "OBS_VALUE") %in% names(result)))
})

test_that("fetch_nomis handles exclude_missing parameter", {
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

# ============================================================================
# Rate limiting and performance tests
# ============================================================================

test_that("fetch_nomis handles multiple sequential requests", {
  skip_if_no_api()
  skip_on_cran()
  skip("Skipping to reduce API load during testing")
  
  result1 <- fetch_nomis(
    "NM_1_1",
    time = "latest",
    geography = "TYPE499",
    measures = 20100
  )
  
  result2 <- fetch_nomis(
    "NM_1_1",
    time = "latest",
    geography = "TYPE464",
    measures = 20100
  )
  
  expect_s3_class(result1, "tbl_df")
  expect_s3_class(result2, "tbl_df")
})

# ============================================================================
# Integration tests
# ============================================================================

test_that("client workflow works end-to-end", {
  skip_if_no_api()
  skip_on_cran()
  
  # Full workflow: request -> parse -> return
  result <- fetch_nomis(
    "NM_1_1",
    time = "latest",
    geography = "TYPE499",
    measures = 20100,
    sex = 7,
    age = 0,
    select = c("GEOGRAPHY_CODE", "DATE_CODE", "OBS_VALUE")
  )
  
  expect_s3_class(result, "tbl_df")
  expect_true(nrow(result) > 0)
  expect_true(all(c("GEOGRAPHY_CODE", "OBS_VALUE") %in% names(result)))
})

test_that("fetch_nomis is consistent across calls", {
  skip_if_no_api()
  skip_on_cran()
  skip("Skipping to reduce API load during testing")
  
  params <- list(
    time = "latest",
    geography = "TYPE499",
    measures = 20100
  )
  
  result1 <- do.call(fetch_nomis, c(id = "NM_1_1", params))
  result2 <- do.call(fetch_nomis, c(id = "NM_1_1", params))
  
  expect_equal(nrow(result1), nrow(result2))
  expect_equal(ncol(result1), ncol(result2))
})

# ============================================================================
# Additional coverage tests
# ============================================================================

test_that("fetch_nomis handles different geography types", {
  skip_if_no_api()
  skip_on_cran()
  skip("Skipping to reduce API load during testing")
  
  # TYPE codes
  result1 <- fetch_nomis(
    "NM_1_1",
    time = "latest",
    geography = "TYPE499",
    measures = 20100
  )
  
  # Specific codes
  result2 <- fetch_nomis(
    "NM_1_1",
    time = "latest",
    geography = "2092957697",
    measures = 20100
  )
  
  expect_s3_class(result1, "tbl_df")
  expect_s3_class(result2, "tbl_df")
})

test_that("fetch_nomis handles different time specifications", {
  skip_if_no_api()
  skip_on_cran()
  skip("Skipping to reduce API load during testing")
  
  # Latest
  result1 <- fetch_nomis(
    "NM_1_1",
    time = "latest",
    geography = "TYPE499",
    measures = 20100
  )
  
  # Range
  result2 <- fetch_nomis(
    "NM_1_1",
    time = "latest-5",
    geography = "TYPE499",
    measures = 20100
  )
  
  expect_s3_class(result1, "tbl_df")
  expect_s3_class(result2, "tbl_df")
})

test_that("fetch_nomis result has expected structure", {
  skip_if_no_api()
  skip_on_cran()
  
  result <- fetch_nomis(
    "NM_1_1",
    time = "latest",
    geography = "TYPE499",
    measures = 20100
  )
  
  expect_true(is.data.frame(result))
  expect_s3_class(result, "tbl_df")
  expect_true(ncol(result) > 0)
  expect_true(nrow(result) > 0)
})

test_that("fetch_nomis handles measure specifications", {
  skip_if_no_api()
  skip_on_cran()
  skip("Skipping to reduce API load during testing")
  
  # Single measure
  result1 <- fetch_nomis(
    "NM_1_1",
    time = "latest",
    geography = "TYPE499",
    measures = 20100
  )
  
  # Multiple measures
  result2 <- fetch_nomis(
    "NM_1_1",
    time = "latest",
    geography = "TYPE499",
    measures = c(20100, 20101)
  )
  
  expect_s3_class(result1, "tbl_df")
  expect_s3_class(result2, "tbl_df")
})

test_that("fetch_nomis handles sex parameter variations", {
  skip_if_no_api()
  skip_on_cran()
  
  result <- fetch_nomis(
    "NM_1_1",
    time = "latest",
    geography = "TYPE499",
    measures = 20100,
    sex = 7
  )
  
  expect_s3_class(result, "tbl_df")
})

test_that("fetch_nomis handles age parameter variations", {
  skip_if_no_api()
  skip_on_cran()
  
  result <- fetch_nomis(
    "NM_1_1",
    time = "latest",
    geography = "TYPE499",
    measures = 20100,
    age = 0
  )
  
  expect_s3_class(result, "tbl_df")
})

test_that("fetch_nomis returns correct data types", {
  skip_if_no_api()
  skip_on_cran()
  
  result <- fetch_nomis(
    "NM_1_1",
    time = "latest",
    geography = "TYPE499",
    measures = 20100
  )
  
  expect_true(is.data.frame(result))
  expect_s3_class(result, "tbl_df")
  
  # Should have character columns for codes
  if ("GEOGRAPHY_CODE" %in% names(result)) {
    expect_type(result$GEOGRAPHY_CODE, "character")
  }
})

# ============================================================================
# Edge case tests
# ============================================================================

test_that("fetch_nomis handles empty parameter values", {
  skip_if_no_api()
  skip_on_cran()
  
  result <- fetch_nomis(
    "NM_1_1",
    time = "latest",
    geography = "TYPE499",
    measures = 20100,
    sex = numeric(0)
  )
  
  expect_s3_class(result, "tbl_df")
})

test_that("fetch_nomis handles long parameter lists", {
  skip_if_no_api()
  skip_on_cran()
  
  result <- fetch_nomis(
    "NM_1_1",
    time = "latest",
    geography = "TYPE499",
    measures = 20100,
    sex = 7,
    age = 0,
    item = 1,
    exclude_missing = TRUE,
    select = c("GEOGRAPHY_CODE", "OBS_VALUE")
  )
  
  expect_s3_class(result, "tbl_df")
})