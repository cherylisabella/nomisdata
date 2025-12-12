# search_datasets()
test_that("search_datasets requires parameter", {
  expect_error(search_datasets(), "At least one search parameter required")
})

test_that("search_datasets returns empty on NULL keyfamily", {
  local_mocked_bindings(
    build_request = function(...) list(),
    execute_request = function(...) structure(list(), class = "httr2_response"),
    parse_json_response = function(...) list(structure = list(keyfamilies = list(keyfamily = NULL)))
  )
  
  expect_message(result <- search_datasets(name = "*test*"), "No datasets found")
  expect_equal(nrow(result), 0)
})

# dataset_overview()
test_that("dataset_overview requires id", {
  expect_error(dataset_overview(), "Dataset ID required")
})

test_that("dataset_overview returns name-value pairs", {
  local_mocked_bindings(
    build_request = function(...) list(),
    execute_request = function(...) structure(list(), class = "httr2_response"),
    parse_json_response = function(...) list(overview = list(Keywords = "test", Units = "persons"))
  )
  
  result <- dataset_overview("NM_1_1")
  expect_equal(names(result), c("name", "value"))
  expect_equal(nrow(result), 2)
})

test_that("dataset_overview handles select parameter", {
  params_captured <- NULL
  
  local_mocked_bindings(
    build_request = function(path, params, format) {
      params_captured <<- params
      list()
    },
    execute_request = function(...) structure(list(), class = "httr2_response"),
    parse_json_response = function(...) list(overview = list(Keywords = "test"))
  )
  
  result <- dataset_overview("NM_1_1", select = c("Keywords", "Units"))
  expect_equal(params_captured$select, "Keywords,Units")
})