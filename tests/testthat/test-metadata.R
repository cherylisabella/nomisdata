# get_codes() - Input validation
test_that("get_codes requires id parameter", {
  expect_error(get_codes(), "Dataset ID is required")
  expect_error(get_codes(id = NULL), "required")
  expect_error(get_codes(id = ""), "required")
})

# get_codes() - concept=NULL path
test_that("get_codes extracts from components.dimension", {
  local_mocked_bindings(
    describe_dataset = function(id) {
      list(
        components.dimension = list(
          list(id = "geo", name = "Geography"),
          list(id = "sex", name = "Sex")
        )
      )
    }
  )
  
  result <- get_codes("NM_1_1")
  expect_s3_class(result, "tbl_df")
  expect_equal(nrow(result), 2)
})

test_that("get_codes falls back to grep", {
  local_mocked_bindings(
    describe_dataset = function(id) {
      data.frame(
        dimension_geography = "GEO",
        dimension_time = "TIME",
        other = "DATA"
      )
    }
  )
  
  result <- get_codes("NM_1_1")
  expect_s3_class(result, "data.frame")
  expect_equal(ncol(result), 2)
})

test_that("get_codes uses dataset_overview fallback", {
  local_mocked_bindings(
    describe_dataset = function(id) list(no_dims = "here"),
    dataset_overview = function(...) list(value = list(data.frame(id = "geo")))
  )
  
  expect_message(result <- get_codes("NM_1_1"), "alternative")
  expect_s3_class(result, "tbl_df")
})

test_that("get_codes errors when no dimensions", {
  local_mocked_bindings(
    describe_dataset = function(id) list(other = "data"),
    dataset_overview = function(...) list(value = list())
  )
  
  expect_error(suppressMessages(get_codes("NM_1_1")), "Could not extract")
})

# fetch_codelist()
test_that("fetch_codelist requires both parameters", {
  expect_error(fetch_codelist(), "Both.*required")
  expect_error(fetch_codelist(id = "NM_1_1"), "required")
})

test_that("get_codes handles overview with non-dataframe value", {
  skip_on_cran()
  
  mock_info <- list(other = "data")
  mock_overview <- list(value = list("not a dataframe"))
  
  local_mocked_bindings(
    describe_dataset = function(...) mock_info,
    dataset_overview = function(...) mock_overview
  )
  
  expect_error(
    suppressMessages(get_codes("NM_1_1")),
    "Could not extract"
  )
})

test_that("get_codes handles overview value that is not NULL but empty list", {
  skip_on_cran()
  
  mock_info <- list(other = "data")
  mock_overview <- list(value = list(NULL))
  
  local_mocked_bindings(
    describe_dataset = function(...) mock_info,
    dataset_overview = function(...) mock_overview
  )
  
  expect_error(
    suppressMessages(get_codes("NM_1_1")),
    "Could not extract"
  )
})

test_that("cache_data handles data with zero rows", {
  skip_on_cran()
  
  cache_dir <- tempfile()
  dir.create(cache_dir)
  withr::defer(unlink(cache_dir, recursive = TRUE))
  
  options(nomisdata.cache_dir = cache_dir)
  withr::defer(options(nomisdata.cache_dir = NULL))
  
  empty_data <- data.frame(x = integer(0), y = character(0))
  result <- nomisdata:::cache_data("empty", empty_data)
  
  expect_true(file.exists(result))
  
  meta <- readRDS(file.path(cache_dir, "empty_meta.rds"))
  expect_equal(meta$rows, 0)
})