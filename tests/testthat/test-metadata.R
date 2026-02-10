test_that("get_codes validates id parameter", {
  expect_error(get_codes(), "Dataset ID")
  expect_error(get_codes(NULL), "Dataset ID")
  expect_error(get_codes(""), "Dataset ID")
})

test_that("fetch_codelist validates parameters", {
  expect_error(fetch_codelist(), "Both")
  expect_error(fetch_codelist(id = "NM_1_1"), "Both")
  expect_error(fetch_codelist(concept = "geography"), "Both")
})

test_that("get_codes handles components.dimension extraction", {
  mock_info <- tibble::tibble(
    components.dimension = list(list(data.frame(id = "geo")))
  )
  local_mocked_bindings(describe_dataset = function(...) mock_info)
  result <- get_codes("NM_1_1")
  expect_s3_class(result, "tbl_df")
})

test_that("get_codes tries dimension column fallback", {
  mock_info <- tibble::tibble(dimension_test = "val")
  local_mocked_bindings(describe_dataset = function(...) mock_info)
  result <- suppressWarnings(get_codes("NM_1_1"))
  expect_s3_class(result, "tbl_df")
})

test_that("get_codes uses dataset_overview as fallback", {
  mock_info <- tibble::tibble(x = 1)
  mock_overview <- tibble::tibble(value = list(data.frame(id = "test")))
  local_mocked_bindings(
    describe_dataset = function(...) mock_info,
    dataset_overview = function(...) mock_overview
  )
  expect_message(suppressWarnings(get_codes("NM_1_1")), "alternative")
})

test_that("get_codes aborts when all extraction fails", {
  mock_info <- tibble::tibble(x = 1)
  mock_overview <- tibble::tibble(value = list(NULL))
  local_mocked_bindings(
    describe_dataset = function(...) mock_info,
    dataset_overview = function(...) mock_overview
  )
  expect_error(suppressWarnings(get_codes("NM_1_1")), "Could not extract")
})