# Tests for metadata retrieval functions

test_that("get_codes requires dataset ID", {
  expect_error(
    get_codes(),
    "Dataset ID is required"
  )
  
  expect_error(
    get_codes(NULL),
    "Dataset ID is required"
  )
  
  expect_error(
    get_codes(""),
    "Dataset ID is required"
  )
})

test_that("get_codes returns dimensions when no concept specified", {
  skip_if_no_api()
  skip_on_cran()
  
  result <- get_codes("NM_1_1")
  
  expect_s3_class(result, "tbl_df")
  expect_true(nrow(result) > 0)
})

test_that("get_codes returns concept codes", {
  skip_if_no_api()
  skip_on_cran()
  skip_if_not_installed("rsdmx")
  
  result <- get_codes("NM_1_1", "geography", "TYPE499")
  
  expect_s3_class(result, "tbl_df")
  # May be empty if no matches, but should be a tibble
})

test_that("get_codes handles search parameter", {
  skip_if_no_api()
  skip_on_cran()
  skip_if_not_installed("rsdmx")
  
  # Suppress informational messages about no results
  result <- suppressMessages(
    get_codes("NM_1_1", "geography", search = "*london*")
  )
  
  expect_s3_class(result, "tbl_df")
})
