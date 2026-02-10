# search_datasets validation
test_that("search_datasets requires at least one parameter", {
  expect_error(search_datasets(), "At least one search parameter required")
})

# search_datasets parameter handling
test_that("search_datasets builds searches list from name", {
  local_mocked_bindings(
    build_request = function(path, params, format) {
      expect_match(path, "search=name-")
      structure(list(), class = "httr2_request")
    },
    execute_request = function(...) structure(list(), class = "httr2_response"),
    parse_json_response = function(...) list(structure = list(keyfamilies = list(keyfamily = data.frame(id = "test"))))
  )
  
  result <- search_datasets(name = "test")
  expect_s3_class(result, "tbl_df")
})

test_that("search_datasets collapses name vector", {
  local_mocked_bindings(
    build_request = function(path, ...) {
      expect_match(path, "a,b")
      structure(list(), class = "httr2_request")
    },
    execute_request = function(...) structure(list(), class = "httr2_response"),
    parse_json_response = function(...) list(structure = list(keyfamilies = list(keyfamily = data.frame(id = "x"))))
  )
  
  search_datasets(name = c("a", "b"))
})

test_that("search_datasets handles all parameters", {
  local_mocked_bindings(
    build_request = function(path, ...) {
      expect_match(path, "search=name-")
      expect_match(path, "search=keywords-")
      expect_match(path, "search=description-")
      expect_match(path, "search=contenttype-")
      expect_match(path, "search=units-")
      structure(list(), class = "httr2_request")
    },
    execute_request = function(...) structure(list(), class = "httr2_response"),
    parse_json_response = function(...) list(structure = list(keyfamilies = list(keyfamily = data.frame(id = "x"))))
  )
  
  search_datasets(name = "a", keywords = "b", description = "c", content_type = "d", units = "e")
})

test_that("search_datasets returns empty tibble when no results", {
  local_mocked_bindings(
    build_request = function(...) structure(list(), class = "httr2_request"),
    execute_request = function(...) structure(list(), class = "httr2_response"),
    parse_json_response = function(...) list(structure = list(keyfamilies = list(keyfamily = NULL)))
  )
  
  expect_message(result <- search_datasets(name = "test"), "No datasets found")
  expect_s3_class(result, "tbl_df")
  expect_equal(nrow(result), 0)
})

# describe_dataset tests
test_that("describe_dataset builds path without id", {
  local_mocked_bindings(
    build_request = function(path, ...) {
      expect_equal(path, "def.sdmx.json")
      structure(list(), class = "httr2_request")
    },
    execute_request = function(...) structure(list(), class = "httr2_response"),
    parse_json_response = function(...) list(structure = list(keyfamilies = list(keyfamily = data.frame(id = "x"))))
  )
  
  result <- describe_dataset()
  expect_s3_class(result, "tbl_df")
})

test_that("describe_dataset builds path with id", {
  local_mocked_bindings(
    build_request = function(path, ...) {
      expect_equal(path, "NM_1_1/def.sdmx.json")
      structure(list(), class = "httr2_request")
    },
    execute_request = function(...) structure(list(), class = "httr2_response"),
    parse_json_response = function(...) list(structure = list(keyfamilies = list(keyfamily = data.frame(id = "x"))))
  )
  
  result <- describe_dataset("NM_1_1")
  expect_s3_class(result, "tbl_df")
})

test_that("describe_dataset handles NULL id", {
  local_mocked_bindings(
    build_request = function(path, ...) {
      expect_equal(path, "def.sdmx.json")
      structure(list(), class = "httr2_request")
    },
    execute_request = function(...) structure(list(), class = "httr2_response"),
    parse_json_response = function(...) list(structure = list(keyfamilies = list(keyfamily = data.frame(id = "x"))))
  )
  
  result <- describe_dataset(id = NULL)
  expect_s3_class(result, "tbl_df")
})

# dataset_overview tests
test_that("dataset_overview requires id", {
  expect_error(dataset_overview(), "Dataset ID required")
})

test_that("dataset_overview builds path correctly", {
  local_mocked_bindings(
    build_request = function(path, params, ...) {
      expect_equal(path, "NM_1_1.overview.json")
      expect_equal(length(params), 0)
      structure(list(), class = "httr2_request")
    },
    execute_request = function(...) structure(list(), class = "httr2_response"),
    parse_json_response = function(...) list(overview = list(name = "test", value = "data"))
  )
  
  result <- dataset_overview("NM_1_1")
  expect_s3_class(result, "tbl_df")
})

test_that("dataset_overview handles select parameter", {
  local_mocked_bindings(
    build_request = function(path, params, ...) {
      expect_equal(params$select, "Keywords,Units")
      structure(list(), class = "httr2_request")
    },
    execute_request = function(...) structure(list(), class = "httr2_response"),
    parse_json_response = function(...) list(overview = list(a = 1))
  )
  
  dataset_overview("NM_1_1", select = c("Keywords", "Units"))
})

test_that("dataset_overview handles NULL select", {
  local_mocked_bindings(
    build_request = function(path, params, ...) {
      expect_equal(length(params), 0)
      structure(list(), class = "httr2_request")
    },
    execute_request = function(...) structure(list(), class = "httr2_response"),
    parse_json_response = function(...) list(overview = list(a = 1))
  )
  
  dataset_overview("NM_1_1", select = NULL)
})

test_that("dataset_overview uses enframe", {
  local_mocked_bindings(
    build_request = function(...) structure(list(), class = "httr2_request"),
    execute_request = function(...) structure(list(), class = "httr2_response"),
    parse_json_response = function(...) list(overview = list(key1 = "val1", key2 = "val2"))
  )
  
  result <- dataset_overview("NM_1_1")
  expect_equal(names(result), c("name", "value"))
  expect_equal(nrow(result), 2)
})