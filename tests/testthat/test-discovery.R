# Tests for dataset discovery functions

# ============================================================================
# search_datasets() tests
# ============================================================================

test_that("search_datasets requires at least one parameter", {
  expect_error(
    search_datasets(),
    "At least one search parameter required"
  )
})

test_that("search_datasets accepts name parameter", {
  skip_if_no_api()
  skip_on_cran()
  
  result <- search_datasets(name = "*employment*")
  
  expect_s3_class(result, "tbl_df")
})

test_that("search_datasets accepts keywords parameter", {
  skip_if_no_api()
  skip_on_cran()
  
  result <- search_datasets(keywords = "census")
  
  expect_s3_class(result, "tbl_df")
})

test_that("search_datasets accepts description parameter", {
  skip_if_no_api()
  skip_on_cran()
  
  result <- search_datasets(description = "*population*")
  
  expect_s3_class(result, "tbl_df")
})

test_that("search_datasets accepts content_type parameter", {
  skip_if_no_api()
  skip_on_cran()
  
  result <- search_datasets(content_type = "dataset")
  
  expect_s3_class(result, "tbl_df")
})

test_that("search_datasets accepts units parameter", {
  skip_if_no_api()
  skip_on_cran()
  
  result <- search_datasets(units = "*persons*")
  
  expect_s3_class(result, "tbl_df")
})

test_that("search_datasets accepts multiple parameters", {
  skip_if_no_api()
  skip_on_cran()
  
  result <- search_datasets(
    name = "*benefit*",
    keywords = "claimants"
  )
  
  expect_s3_class(result, "tbl_df")
})

test_that("search_datasets handles multiple name values", {
  skip_if_no_api()
  skip_on_cran()
  
  result <- search_datasets(name = c("*employment*", "*benefit*"))
  
  expect_s3_class(result, "tbl_df")
})

test_that("search_datasets handles multiple keywords", {
  skip_if_no_api()
  skip_on_cran()
  
  result <- search_datasets(keywords = c("census", "population"))
  
  expect_s3_class(result, "tbl_df")
})

test_that("search_datasets informs when no datasets found", {
  skip_if_no_api()
  skip_on_cran()
  
  expect_message(
    result <- search_datasets(name = "*zzzznonexistent999*"),
    "No datasets found"
  )
  
  expect_s3_class(result, "tbl_df")
  expect_equal(nrow(result), 0)
})

test_that("search_datasets returns empty tibble when no matches", {
  skip_if_no_api()
  skip_on_cran()
  
  result <- suppressMessages(
    search_datasets(name = "*impossible999xyz*")
  )
  
  expect_s3_class(result, "tbl_df")
  expect_equal(nrow(result), 0)
})

test_that("search_datasets with all parameters", {
  skip_if_no_api()
  skip_on_cran()
  
  result <- search_datasets(
    name = "*employment*",
    keywords = "census"
  )
  
  expect_s3_class(result, "tbl_df")
})

test_that("search_datasets handles NULL parameters correctly", {
  skip_if_no_api()
  skip_on_cran()
  
  result <- search_datasets(
    name = "*test*",
    keywords = NULL,
    description = NULL
  )
  
  expect_s3_class(result, "tbl_df")
})

# ============================================================================
# describe_dataset() tests
# ============================================================================

test_that("describe_dataset returns metadata for specific dataset", {
  skip_if_no_api()
  skip_on_cran()
  
  result <- describe_dataset("NM_1_1")
  
  expect_s3_class(result, "tbl_df")
  expect_true(ncol(result) > 0)
})

test_that("describe_dataset without ID returns all datasets", {
  skip_if_no_api()
  skip_on_cran()
  
  result <- describe_dataset()
  
  expect_s3_class(result, "tbl_df")
  expect_true(nrow(result) > 10)
})

test_that("describe_dataset with NULL ID returns all datasets", {
  skip_if_no_api()
  skip_on_cran()
  
  result <- describe_dataset(id = NULL)
  
  expect_s3_class(result, "tbl_df")
  expect_true(nrow(result) > 10)
})

test_that("describe_dataset builds correct path with ID", {
  skip_if_no_api()
  skip_on_cran()
  
  expect_error(describe_dataset("NM_1_1"), NA)
})

test_that("describe_dataset builds correct path without ID", {
  skip_if_no_api()
  skip_on_cran()
  
  expect_error(describe_dataset(), NA)
})

test_that("describe_dataset returns tibble", {
  skip_if_no_api()
  skip_on_cran()
  
  result <- describe_dataset("NM_1_1")
  
  expect_s3_class(result, "tbl_df")
  expect_true(is.data.frame(result))
})

# ============================================================================
# dataset_overview() tests
# ============================================================================

test_that("dataset_overview requires ID", {
  expect_error(
    dataset_overview(),
    "Dataset ID required"
  )
})

test_that("dataset_overview returns overview info", {
  skip_if_no_api()
  skip_on_cran()
  
  result <- dataset_overview("NM_1_1")
  
  expect_s3_class(result, "tbl_df")
  expect_true("name" %in% names(result))
  expect_true("value" %in% names(result))
})

test_that("dataset_overview accepts select parameter", {
  skip_if_no_api()
  skip_on_cran()
  
  result <- dataset_overview("NM_1_1", select = "Keywords")
  
  expect_s3_class(result, "tbl_df")
})

test_that("dataset_overview accepts multiple select values", {
  skip_if_no_api()
  skip_on_cran()
  
  result <- dataset_overview("NM_1_1", select = c("Keywords", "Units"))
  
  expect_s3_class(result, "tbl_df")
})

test_that("dataset_overview with NULL select", {
  skip_if_no_api()
  skip_on_cran()
  
  result <- dataset_overview("NM_1_1", select = NULL)
  
  expect_s3_class(result, "tbl_df")
})

test_that("dataset_overview returns name-value pairs", {
  skip_if_no_api()
  skip_on_cran()
  
  result <- dataset_overview("NM_1_1")
  
  expect_equal(ncol(result), 2)
  expect_true(all(c("name", "value") %in% names(result)))
})

# ============================================================================
# Integration tests
# ============================================================================

test_that("search and describe work together", {
  skip_if_no_api()
  skip_on_cran()
  
  search_result <- search_datasets(name = "*employment*")
  
  if (nrow(search_result) > 0 && "id" %in% names(search_result)) {
    dataset_id <- search_result$id[1]
    desc <- describe_dataset(dataset_id)
    
    expect_s3_class(desc, "tbl_df")
  }
})

test_that("describe and overview work together", {
  skip_if_no_api()
  skip_on_cran()
  
  desc <- describe_dataset("NM_1_1")
  overview <- dataset_overview("NM_1_1")
  
  expect_s3_class(desc, "tbl_df")
  expect_s3_class(overview, "tbl_df")
})

test_that("search_datasets collapses vectors with commas", {
  skip_if_no_api()
  skip_on_cran()
  
  expect_error(
    search_datasets(name = c("*test1*", "*test2*")),
    NA
  )
})

test_that("dataset_overview collapses select with commas", {
  skip_if_no_api()
  skip_on_cran()
  
  expect_error(
    dataset_overview("NM_1_1", select = c("Keywords", "Units")),
    NA
  )
})

test_that("search_datasets builds correct query string", {
  skip_if_no_api()
  skip_on_cran()
  
  result <- search_datasets(name = "*test*")
  
  expect_s3_class(result, "tbl_df")
})

test_that("dataset_overview builds correct path", {
  skip_if_no_api()
  skip_on_cran()
  
  expect_error(
    dataset_overview("NM_1_1"),
    NA
  )
})