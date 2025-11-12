# Tests for dataset discovery functions

test_that("search_datasets requires at least one parameter", {
  expect_error(
    search_datasets(),
    "At least one search parameter required"
  )
})

test_that("search_datasets builds correct query", {
  skip_if_no_api()
  skip_on_cran()
  
  result <- search_datasets(name = "*employment*")
  
  expect_s3_class(result, "tbl_df")
  expect_true(ncol(result) > 0)
})

test_that("describe_dataset returns metadata", {
  skip_if_no_api()
  skip_on_cran()
  
  result <- describe_dataset("NM_1_1")
  
  expect_s3_class(result, "tbl_df")
  expect_true("id" %in% names(result) || "agencyid" %in% names(result))
})

test_that("describe_dataset without ID returns all datasets", {
  skip_if_no_api()
  skip_on_cran()
  
  result <- describe_dataset()
  
  expect_s3_class(result, "tbl_df")
  expect_true(nrow(result) > 10)  # Should have many datasets
})

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
