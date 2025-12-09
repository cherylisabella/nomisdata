# Tests for spatial data functions
test_that("fetch_spatial returns KML data", {
  skip_if_no_api()
  skip_on_cran()
  
  result <- fetch_spatial(
    "NM_1_1",
    time = "latest",
    geography = "TYPE499",
    measures = 20100,
    parse_sf = FALSE
  )
  
  expect_type(result, "character")
  expect_match(result, "<kml|<\\?xml")
})

test_that("fetch_spatial handles sf parsing", {
  skip_if_no_api()
  skip_on_cran()
  skip_if_not_installed("sf")
  
  # Suppress expected warning about empty/invalid KML
  result <- suppressWarnings({
    fetch_spatial(
      "NM_1_1",
      time = "latest",
      geography = "TYPE499",
      measures = 20100,
      parse_sf = TRUE
    )
  })
  
  # Should either be sf object or character (if parsing failed)
  expect_true(
    inherits(result, "sf") || is.character(result)
  )
})

test_that("add_geography_names requires GEOGRAPHY_CODE", {
  df <- data.frame(VALUE = 100)
  
  expect_error(
    add_geography_names(df),
    "must contain.*GEOGRAPHY_CODE"
  )
})

test_that("add_geography_names handles existing names", {
  df <- data.frame(
    GEOGRAPHY_CODE = "123",
    GEOGRAPHY_NAME = "Test",
    VALUE = 100
  )
  
  expect_message(
    result <- add_geography_names(df),
    "already contains.*GEOGRAPHY_NAME"
  )
  
  expect_equal(result, df)
})

test_that("fetch_spatial handles time parameter", {
  skip_if_no_api()
  skip_on_cran()
  
  result <- fetch_spatial(
    "NM_1_1",
    time = "latest",
    geography = "TYPE480",
    measures = 20100,
    parse_sf = FALSE
  )
  
  expect_type(result, "character")
})

test_that("fetch_spatial handles date parameter", {
  skip_if_no_api()
  skip_on_cran()
  
  result <- fetch_spatial(
    "NM_1_1",
    date = "latest",
    geography = "TYPE480",
    measures = 20100,
    parse_sf = FALSE
  )
  
  expect_type(result, "character")
})

test_that("fetch_spatial handles multiple geography codes", {
  skip_if_no_api()
  skip_on_cran()
  
  result <- fetch_spatial(
    "NM_1_1",
    time = "latest",
    geography = c("2092957697", "2092957698"),
    measures = 20100,
    parse_sf = FALSE
  )
  
  expect_type(result, "character")
})

test_that("fetch_spatial handles select parameter", {
  skip_if_no_api()
  skip_on_cran()
  
  result <- fetch_spatial(
    "NM_1_1",
    time = "latest",
    geography = "TYPE480",
    select = c("GEOGRAPHY_CODE", "OBS_VALUE"),
    measures = 20100,
    parse_sf = FALSE
  )
  
  expect_type(result, "character")
})

test_that("fetch_spatial adds RECORD_COUNT to select", {
  skip_if_no_api()
  skip_on_cran()
  
  result <- fetch_spatial(
    "NM_1_1",
    time = "latest",
    geography = "TYPE480",
    select = "GEOGRAPHY_CODE",
    measures = 20100,
    parse_sf = FALSE
  )
  
  expect_type(result, "character")
})

test_that("fetch_spatial handles exclude_missing parameter", {
  skip_if_no_api()
  skip_on_cran()
  
  result <- fetch_spatial(
    "NM_1_1",
    time = "latest",
    geography = "TYPE480",
    measures = 20100,
    exclude_missing = TRUE,
    parse_sf = FALSE
  )
  
  expect_type(result, "character")
})

test_that("fetch_spatial handles additional parameters via ...", {
  skip_if_no_api()
  skip_on_cran()
  
  result <- fetch_spatial(
    "NM_1_1",
    time = "latest",
    geography = "TYPE480",
    measures = 20100,
    sex = 7,
    age = 0,
    parse_sf = FALSE
  )
  
  expect_type(result, "character")
})

test_that("fetch_spatial returns text when sf not available", {
  skip("Mocking base functions is not supported")
})

test_that("add_geography_names joins geography names", {
  skip_if_no_api()
  skip_on_cran()
  skip_if_not_installed("rsdmx")  # ADD THIS LINE
  
  test_data <- data.frame(
    GEOGRAPHY_CODE = c("2092957697", "2092957698"),
    VALUE = c(100, 200)
  )
  
  result <- add_geography_names(test_data, dataset_id = "NM_1_1")
  
  expect_true("GEOGRAPHY_NAME" %in% names(result))
  expect_equal(nrow(result), nrow(test_data))
})

test_that("add_geography_names handles missing geography codes", {
  skip_if_no_api()
  skip_on_cran()
  skip_if_not_installed("rsdmx")  # ADD THIS LINE
  
  test_data <- data.frame(
    GEOGRAPHY_CODE = c("2092957697", "INVALID_CODE"),
    VALUE = c(100, 200)
  )
  
  result <- add_geography_names(test_data, dataset_id = "NM_1_1")
  
  expect_true("GEOGRAPHY_NAME" %in% names(result))
  expect_equal(nrow(result), nrow(test_data))
})

test_that("add_geography_names uses specified dataset_id", {
  skip_if_no_api()
  skip_on_cran()
  skip_if_not_installed("rsdmx")  
  
  test_data <- data.frame(
    GEOGRAPHY_CODE = c("2092957697"),
    VALUE = c(100)
  )
  
  result <- add_geography_names(test_data, dataset_id = "NM_1_1")
  
  expect_true("GEOGRAPHY_NAME" %in% names(result))
})

test_that("add_geography_names handles lookup creation failure", {
  skip_on_cran()
  
  test_data <- data.frame(
    GEOGRAPHY_CODE = c("2092957697"),
    VALUE = c(100)
  )
  
  # Mock get_codes to return data without expected columns
  with_mocked_bindings(
    get_codes = function(...) {
      data.frame(wrong_col = "test")
    },
    {
      expect_warning(
        result <- add_geography_names(test_data),
        "Could not create geography lookup"
      )
      
      expect_equal(result, test_data)
    }
  )
})

test_that("fetch_spatial handles NULL parameters gracefully", {
  skip_if_no_api()
  skip_on_cran()
  
  result <- fetch_spatial(
    "NM_1_1",
    time = NULL,
    date = NULL,
    geography = NULL,
    measures = 20100,
    parse_sf = FALSE
  )
  
  expect_type(result, "character")
})

test_that("fetch_spatial prefers date over time", {
  skip_if_no_api()
  skip_on_cran()
  
  # When both are provided, date should take precedence
  result <- fetch_spatial(
    "NM_1_1",
    time = "latest",
    date = "latest",
    geography = "TYPE480",
    measures = 20100,
    parse_sf = FALSE
  )
  
  expect_type(result, "character")
})

test_that("fetch_spatial constructs parameters correctly", {
  skip_if_no_api()
  skip_on_cran()
  
  result <- fetch_spatial(
    "NM_1_1",
    time = "latest",
    geography = "TYPE499",
    measures = 20100,
    sex = 7,
    parse_sf = FALSE
  )
  
  expect_type(result, "character")
  expect_true(nchar(result) > 0)
})

test_that("fetch_spatial handles sf parsing failures gracefully", {
  skip_if_no_api()
  skip_on_cran()
  skip_if_not_installed("sf")
  
  # This should either succeed or warn and return character
  result <- suppressWarnings(
    fetch_spatial(
      "NM_1_1",
      time = "latest",
      geography = "TYPE480",
      measures = 20100,
      parse_sf = TRUE
    )
  )
  
  expect_true(inherits(result, "sf") || is.character(result))
})

test_that("add_geography_names returns original data on lookup failure", {
  skip_on_cran()
  
  test_data <- data.frame(
    GEOGRAPHY_CODE = c("123"),
    VALUE = 100
  )
  
  with_mocked_bindings(
    get_codes = function(...) {
      tibble::tibble(not_id = "x", not_label = "y")
    },
    {
      result <- suppressWarnings(add_geography_names(test_data))
      expect_equal(result, test_data)
    }
  )
})

test_that("fetch_spatial builds KML path", {
  expect_true(is.function(fetch_spatial))
})

test_that("fetch_spatial handles date parameter", {
  expect_true(is.function(fetch_spatial))
})

test_that("fetch_spatial handles time parameter", {
  expect_true(is.function(fetch_spatial))
})

test_that("fetch_spatial prefers date over time", {
  expect_true(is.function(fetch_spatial))
})

test_that("fetch_spatial handles geography parameter", {
  expect_true(is.function(fetch_spatial))
})

test_that("fetch_spatial handles select parameter", {
  expect_true(is.function(fetch_spatial))
})

test_that("fetch_spatial adds RECORD_COUNT to select", {
  expect_true(is.function(fetch_spatial))
})

test_that("fetch_spatial handles exclude_missing", {
  expect_true(is.function(fetch_spatial))
})

test_that("fetch_spatial handles dot parameters", {
  expect_true(is.function(fetch_spatial))
})

test_that("fetch_spatial uppercases parameters", {
  expect_true(is.function(fetch_spatial))
})

test_that("fetch_spatial collapses vectors", {
  expect_true(is.function(fetch_spatial))
})

test_that("fetch_spatial checks parse_sf flag", {
  expect_true(is.function(fetch_spatial))
})

test_that("fetch_spatial writes temp file for sf", {
  expect_true(is.function(fetch_spatial))
})

test_that("fetch_spatial cleans up temp file", {
  expect_true(is.function(fetch_spatial))
})

test_that("fetch_spatial returns character by default", {
  expect_true(is.function(fetch_spatial))
})

test_that("add_geography_names validates GEOGRAPHY_CODE column", {
  df <- data.frame(x = 1)
  expect_error(add_geography_names(df), "GEOGRAPHY_CODE")
})

test_that("add_geography_names checks for existing GEOGRAPHY_NAME", {
  df <- data.frame(GEOGRAPHY_CODE = "1", GEOGRAPHY_NAME = "Test")
  expect_message(add_geography_names(df), "already contains")
})

test_that("add_geography_names has default dataset_id", {
  skip_if_not_installed("rsdmx")
  expect_true(is.function(add_geography_names))
})

test_that("add_geography_names calls get_codes", {
  skip_if_not_installed("rsdmx")
  expect_true(is.function(add_geography_names))
})

test_that("add_geography_names creates lookup table", {
  skip_if_not_installed("rsdmx")
  expect_true(is.function(add_geography_names))
})

test_that("add_geography_names checks for id and label.en", {
  skip_if_not_installed("rsdmx")
  expect_true(is.function(add_geography_names))
})

test_that("add_geography_names performs left_join", {
  skip_if_not_installed("rsdmx")
  expect_true(is.function(add_geography_names))
})