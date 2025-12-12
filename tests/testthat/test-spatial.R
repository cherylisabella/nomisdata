# fetch_spatial() - Parameter handling
test_that("fetch_spatial handles date over time", {
  params_captured <- NULL
  
  local_mocked_bindings(
    build_request = function(path, params, format) {
      params_captured <<- params
      list()
    },
    execute_request = function(...) {
      resp <- structure(list(), class = "httr2_response")
      resp$body <- charToRaw("<kml/>")
      resp
    }
  )
  
  result <- fetch_spatial("NM_1_1", date = "latest", time = "2020", parse_sf = FALSE)
  
  expect_true("date" %in% names(params_captured))
  expect_false("time" %in% names(params_captured))
})

test_that("fetch_spatial uses time when date NULL", {
  params_captured <- NULL
  
  local_mocked_bindings(
    build_request = function(path, params, format) {
      params_captured <<- params
      list()
    },
    execute_request = function(...) {
      resp <- structure(list(), class = "httr2_response")
      resp$body <- charToRaw("<kml/>")
      resp
    }
  )
  
  result <- fetch_spatial("NM_1_1", time = "latest", parse_sf = FALSE)
  expect_true("time" %in% names(params_captured))
})

test_that("fetch_spatial collapses geography vector", {
  params_captured <- NULL
  
  local_mocked_bindings(
    build_request = function(path, params, format) {
      params_captured <<- params
      list()
    },
    execute_request = function(...) {
      resp <- structure(list(), class = "httr2_response")
      resp$body <- charToRaw("<kml/>")
      resp
    }
  )
  
  result <- fetch_spatial("NM_1_1", geography = c("A", "B"), parse_sf = FALSE)
  expect_equal(params_captured$geography, "A,B")
})

test_that("fetch_spatial uppercases and adds RECORD_COUNT", {
  params_captured <- NULL
  
  local_mocked_bindings(
    build_request = function(path, params, format) {
      params_captured <<- params
      list()
    },
    execute_request = function(...) {
      resp <- structure(list(), class = "httr2_response")
      resp$body <- charToRaw("<kml/>")
      resp
    }
  )
  
  result <- fetch_spatial("NM_1_1", select = "geography_code", parse_sf = FALSE)
  expect_match(params_captured$select, "GEOGRAPHY_CODE")
  expect_match(params_captured$select, "RECORD_COUNT")
})

test_that("fetch_spatial sets ExcludeMissingValues when TRUE", {
  params_captured <- NULL
  
  local_mocked_bindings(
    build_request = function(path, params, format) {
      params_captured <<- params
      list()
    },
    execute_request = function(...) {
      resp <- structure(list(), class = "httr2_response")
      resp$body <- charToRaw("<kml/>")
      resp
    }
  )
  
  result <- fetch_spatial("NM_1_1", exclude_missing = TRUE, parse_sf = FALSE)
  expect_equal(params_captured$ExcludeMissingValues, "true")
})

test_that("fetch_spatial skips ExcludeMissingValues when FALSE", {
  params_captured <- NULL
  
  local_mocked_bindings(
    build_request = function(path, params, format) {
      params_captured <<- params
      list()
    },
    execute_request = function(...) {
      resp <- structure(list(), class = "httr2_response")
      resp$body <- charToRaw("<kml/>")
      resp
    }
  )
  
  result <- fetch_spatial("NM_1_1", exclude_missing = FALSE, parse_sf = FALSE)
  expect_false("ExcludeMissingValues" %in% names(params_captured))
})

test_that("fetch_spatial uppercases additional parameters", {
  params_captured <- NULL
  
  local_mocked_bindings(
    build_request = function(path, params, format) {
      params_captured <<- params
      list()
    },
    execute_request = function(...) {
      resp <- structure(list(), class = "httr2_response")
      resp$body <- charToRaw("<kml/>")
      resp
    }
  )
  
  result <- fetch_spatial("NM_1_1", measures = 20100, sex = 7, parse_sf = FALSE)
  expect_true("MEASURES" %in% names(params_captured))
  expect_true("SEX" %in% names(params_captured))
})

test_that("fetch_spatial skips empty parameters", {
  params_captured <- NULL
  
  local_mocked_bindings(
    build_request = function(path, params, format) {
      params_captured <<- params
      list()
    },
    execute_request = function(...) {
      resp <- structure(list(), class = "httr2_response")
      resp$body <- charToRaw("<kml/>")
      resp
    }
  )
  
  result <- fetch_spatial("NM_1_1", sex = numeric(0), parse_sf = FALSE)
  expect_false("SEX" %in% names(params_captured))
})

# add_geography_names()
test_that("add_geography_names requires GEOGRAPHY_CODE", {
  expect_error(add_geography_names(data.frame(a = 1)), "GEOGRAPHY_CODE")
})

test_that("add_geography_names returns early if name exists", {
  df <- data.frame(GEOGRAPHY_CODE = "1", GEOGRAPHY_NAME = "Test")
  expect_message(result <- add_geography_names(df), "already contains")
  expect_identical(result, df)
})

test_that("add_geography_names joins lookup", {
  local_mocked_bindings(
    get_codes = function(...) tibble::tibble(id = "1", label.en = "Place")
  )
  
  result <- add_geography_names(data.frame(GEOGRAPHY_CODE = "1"))
  expect_true("GEOGRAPHY_NAME" %in% names(result))
})

test_that("add_geography_names warns when columns missing", {
  local_mocked_bindings(
    get_codes = function(...) tibble::tibble(wrong = "col")
  )
  
  expect_warning(add_geography_names(data.frame(GEOGRAPHY_CODE = "1")), "lookup")
})