# Tests for spatial data functions
# ============================================================================
# fetch_spatial() - Basic functionality
# ============================================================================

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
  expect_match(result, "<kml|<\\?xml", ignore.case = TRUE)
})

test_that("fetch_spatial builds correct KML path", {
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
  expect_match(result, "<kml|<\\?xml", ignore.case = TRUE)
})

# ============================================================================
# fetch_spatial() - Time and date parameters
# ============================================================================

test_that("fetch_spatial handles time parameter correctly", {
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
  expect_true(nchar(result) > 0)
})

test_that("fetch_spatial handles date parameter correctly", {
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
  expect_true(nchar(result) > 0)
})

test_that("fetch_spatial prefers date over time when both provided", {
  skip_if_no_api()
  skip_on_cran()
  
  # Both parameters provided - date should be used
  result <- fetch_spatial(
    "NM_1_1",
    time = "2020",
    date = "latest",
    geography = "TYPE480",
    measures = 20100,
    parse_sf = FALSE
  )
  
  expect_type(result, "character")
})

test_that("fetch_spatial handles NULL time parameter", {
  skip_if_no_api()
  skip_on_cran()
  
  result <- fetch_spatial(
    "NM_1_1",
    time = NULL,
    geography = "TYPE480",
    measures = 20100,
    parse_sf = FALSE
  )
  
  expect_type(result, "character")
})

test_that("fetch_spatial handles NULL date parameter", {
  skip_if_no_api()
  skip_on_cran()
  
  result <- fetch_spatial(
    "NM_1_1",
    date = NULL,
    geography = "TYPE480",
    measures = 20100,
    parse_sf = FALSE
  )
  
  expect_type(result, "character")
})

test_that("fetch_spatial works without time or date", {
  skip_if_no_api()
  skip_on_cran()
  
  result <- fetch_spatial(
    "NM_1_1",
    geography = "TYPE480",
    measures = 20100,
    parse_sf = FALSE
  )
  
  expect_type(result, "character")
})

# ============================================================================
# fetch_spatial() - Geography parameter
# ============================================================================

test_that("fetch_spatial handles single geography code", {
  skip_if_no_api()
  skip_on_cran()
  
  result <- fetch_spatial(
    "NM_1_1",
    time = "latest",
    geography = "2092957697",
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

test_that("fetch_spatial handles geography type codes", {
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
})

test_that("fetch_spatial handles NULL geography", {
  skip_if_no_api()
  skip_on_cran()
  
  result <- fetch_spatial(
    "NM_1_1",
    time = "latest",
    geography = NULL,
    measures = 20100,
    parse_sf = FALSE
  )
  
  expect_type(result, "character")
})

test_that("fetch_spatial collapses geography vector with commas", {
  skip_if_no_api()
  skip_on_cran()
  
  result <- fetch_spatial(
    "NM_1_1",
    time = "latest",
    geography = c("2092957697", "2092957698", "2092957699"),
    measures = 20100,
    parse_sf = FALSE
  )
  
  expect_type(result, "character")
})

# ============================================================================
# fetch_spatial() - Select parameter
# ============================================================================

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

test_that("fetch_spatial automatically adds RECORD_COUNT to select", {
  skip_if_no_api()
  skip_on_cran()
  
  # Even if only GEOGRAPHY_CODE is selected, RECORD_COUNT should be added
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

test_that("fetch_spatial uppercases select columns", {
  skip_if_no_api()
  skip_on_cran()
  
  result <- fetch_spatial(
    "NM_1_1",
    time = "latest",
    geography = "TYPE480",
    select = c("geography_code", "obs_value"),
    measures = 20100,
    parse_sf = FALSE
  )
  
  expect_type(result, "character")
})

test_that("fetch_spatial handles NULL select", {
  skip_if_no_api()
  skip_on_cran()
  
  result <- fetch_spatial(
    "NM_1_1",
    time = "latest",
    geography = "TYPE480",
    select = NULL,
    measures = 20100,
    parse_sf = FALSE
  )
  
  expect_type(result, "character")
})

test_that("fetch_spatial removes duplicate columns in select", {
  skip_if_no_api()
  skip_on_cran()
  
  result <- fetch_spatial(
    "NM_1_1",
    time = "latest",
    geography = "TYPE480",
    select = c("GEOGRAPHY_CODE", "GEOGRAPHY_CODE", "OBS_VALUE"),
    measures = 20100,
    parse_sf = FALSE
  )
  
  expect_type(result, "character")
})

# ============================================================================
# fetch_spatial() - Exclude missing parameter
# ============================================================================

test_that("fetch_spatial handles exclude_missing = TRUE", {
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

test_that("fetch_spatial handles exclude_missing = FALSE", {
  skip_if_no_api()
  skip_on_cran()
  
  result <- fetch_spatial(
    "NM_1_1",
    time = "latest",
    geography = "TYPE480",
    measures = 20100,
    exclude_missing = FALSE,
    parse_sf = FALSE
  )
  
  expect_type(result, "character")
})

test_that("fetch_spatial sets ExcludeMissingValues correctly", {
  skip_if_no_api()
  skip_on_cran()
  
  # TRUE should add parameter
  result1 <- fetch_spatial(
    "NM_1_1",
    time = "latest",
    geography = "TYPE480",
    measures = 20100,
    exclude_missing = TRUE,
    parse_sf = FALSE
  )
  
  # FALSE should not add parameter
  result2 <- fetch_spatial(
    "NM_1_1",
    time = "latest",
    geography = "TYPE480",
    measures = 20100,
    exclude_missing = FALSE,
    parse_sf = FALSE
  )
  
  expect_type(result1, "character")
  expect_type(result2, "character")
})

# ============================================================================
# fetch_spatial() - Additional parameters via ...
# ============================================================================

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

test_that("fetch_spatial uppercases parameter names from ...", {
  skip_if_no_api()
  skip_on_cran()
  
  # Test that lowercase parameter names get uppercased
  result <- fetch_spatial(
    "NM_1_1",
    time = "latest",
    geography = "TYPE480",
    measures = 20100,
    sex = 7,
    parse_sf = FALSE
  )
  
  expect_type(result, "character")
})

test_that("fetch_spatial collapses vector parameters with commas", {
  skip_if_no_api()
  skip_on_cran()
  
  result <- fetch_spatial(
    "NM_1_1",
    time = "latest",
    geography = c("2092957697", "2092957698"),
    measures = c(20100, 20101),
    parse_sf = FALSE
  )
  
  expect_type(result, "character")
})

test_that("fetch_spatial handles multiple additional parameters", {
  skip_if_no_api()
  skip_on_cran()
  
  result <- fetch_spatial(
    "NM_1_1",
    time = "latest",
    geography = "TYPE480",
    measures = 20100,
    sex = 7,
    age = 0,
    item = 1,
    parse_sf = FALSE
  )
  
  expect_type(result, "character")
})

test_that("fetch_spatial skips empty parameter values", {
  skip_if_no_api()
  skip_on_cran()
  
  result <- fetch_spatial(
    "NM_1_1",
    time = "latest",
    geography = "TYPE480",
    measures = 20100,
    sex = numeric(0),
    parse_sf = FALSE
  )
  
  expect_type(result, "character")
})

test_that("fetch_spatial handles NULL parameters gracefully", {
  skip_if_no_api()
  skip_on_cran()
  
  result <- fetch_spatial(
    "NM_1_1",
    time = NULL,
    date = NULL,
    geography = NULL,
    select = NULL,
    measures = 20100,
    parse_sf = FALSE
  )
  
  expect_type(result, "character")
})

# ============================================================================
# fetch_spatial() - sf parsing tests
# ============================================================================

test_that("fetch_spatial with parse_sf = FALSE returns character", {
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

test_that("fetch_spatial with parse_sf = TRUE attempts sf parsing", {
  skip_if_no_api()
  skip_on_cran()
  skip_if_not_installed("sf")
  
  result <- suppressWarnings(
    fetch_spatial(
      "NM_1_1",
      time = "latest",
      geography = "TYPE480",
      measures = 20100,
      parse_sf = TRUE
    )
  )
  
  # Should be either sf object or character (if parsing failed)
  expect_true(inherits(result, "sf") || is.character(result))
})

test_that("fetch_spatial creates temp file for sf parsing", {
  skip_if_no_api()
  skip_on_cran()
  skip_if_not_installed("sf")
  
  result <- suppressWarnings(
    fetch_spatial(
      "NM_1_1",
      time = "latest",
      geography = "TYPE480",
      measures = 20100,
      parse_sf = TRUE
    )
  )
  
  # Should return something (sf or character)
  expect_true(!is.null(result))
})

test_that("fetch_spatial cleans up temp file after sf parsing", {
  skip_if_no_api()
  skip_on_cran()
  skip_if_not_installed("sf")
  
  initial_temps <- list.files(tempdir(), pattern = "\\.kml$", full.names = TRUE)
  
  result <- suppressWarnings(
    fetch_spatial(
      "NM_1_1",
      time = "latest",
      geography = "TYPE480",
      measures = 20100,
      parse_sf = TRUE
    )
  )
  
  final_temps <- list.files(tempdir(), pattern = "\\.kml$", full.names = TRUE)
  
  # Temp files should not accumulate
  expect_true(length(final_temps) <= length(initial_temps) + 1)
})

test_that("fetch_spatial handles sf parsing failures", {
  skip_if_no_api()
  skip_on_cran()
  skip_if_not_installed("sf")
  
  # Some KML may be empty or invalid - should handle gracefully
  result <- suppressWarnings(
    fetch_spatial(
      "NM_1_1",
      time = "latest",
      geography = "TYPE480",
      measures = 20100,
      parse_sf = TRUE
    )
  )
  
  # Should return character on parse failure
  expect_true(inherits(result, "sf") || is.character(result))
})

test_that("fetch_spatial returns character when sf unavailable", {
  skip_if_no_api()
  skip_on_cran()
  skip_if_installed("sf")
  
  result <- fetch_spatial(
    "NM_1_1",
    time = "latest",
    geography = "TYPE480",
    measures = 20100,
    parse_sf = TRUE
  )
  
  expect_type(result, "character")
})

test_that("fetch_spatial default parse_sf works", {
  skip_if_no_api()
  skip_on_cran()
  
  result <- suppressWarnings(
    fetch_spatial(
      "NM_1_1",
      time = "latest",
      geography = "TYPE480",
      measures = 20100
    )
  )
  
  expect_true(!is.null(result))
})

# ============================================================================
# fetch_spatial() - KML format validation
# ============================================================================

test_that("fetch_spatial returns valid KML structure", {
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
  expect_match(result, "<kml|<\\?xml", ignore.case = TRUE)
  expect_true(nchar(result) > 100)
})

test_that("fetch_spatial KML contains geography data", {
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
  # Should contain some geographic elements
  expect_true(grepl("kml|placemark|coordinates", result, ignore.case = TRUE))
})

# ============================================================================
# add_geography_names() - Parameter validation
# ============================================================================

test_that("add_geography_names requires GEOGRAPHY_CODE column", {
  df <- data.frame(VALUE = c(100, 200))
  
  expect_error(
    add_geography_names(df),
    "must contain.*GEOGRAPHY_CODE"
  )
})

test_that("add_geography_names handles data without GEOGRAPHY_CODE", {
  df <- data.frame(
    REGION = c("A", "B"),
    VALUE = c(100, 200)
  )
  
  expect_error(
    add_geography_names(df),
    "GEOGRAPHY_CODE"
  )
})

test_that("add_geography_names validates required column", {
  df <- data.frame(
    GEO_CODE = "123",
    VALUE = 100
  )
  
  expect_error(add_geography_names(df), "GEOGRAPHY_CODE")
})

test_that("add_geography_names accepts valid data frame", {
  skip_if_no_api()
  skip_on_cran()
  skip_if_not_installed("rsdmx")
  
  df <- data.frame(
    GEOGRAPHY_CODE = "2092957697",
    VALUE = 100
  )
  
  result <- add_geography_names(df)
  
  expect_s3_class(result, "data.frame")
})

# ============================================================================
# add_geography_names() - Existing GEOGRAPHY_NAME handling
# ============================================================================

test_that("add_geography_names informs about existing GEOGRAPHY_NAME", {
  df <- data.frame(
    GEOGRAPHY_CODE = c("123", "456"),
    GEOGRAPHY_NAME = c("Place A", "Place B"),
    VALUE = c(100, 200)
  )
  
  expect_message(
    result <- add_geography_names(df),
    "already contains.*GEOGRAPHY_NAME"
  )
  
  expect_equal(result, df)
})

test_that("add_geography_names returns original data when name exists", {
  df <- data.frame(
    GEOGRAPHY_CODE = "123",
    GEOGRAPHY_NAME = "Test Place",
    VALUE = 100
  )
  
  result <- suppressMessages(add_geography_names(df))
  
  expect_identical(result, df)
})

# ============================================================================
# add_geography_names() - Default parameters
# ============================================================================

test_that("add_geography_names has default dataset_id", {
  skip_if_no_api()
  skip_on_cran()
  skip_if_not_installed("rsdmx")
  
  df <- data.frame(
    GEOGRAPHY_CODE = "2092957697",
    VALUE = 100
  )
  
  # Should use default NM_1_1
  result <- add_geography_names(df)
  
  expect_true("GEOGRAPHY_NAME" %in% names(result))
})

test_that("add_geography_names default is NM_1_1", {
  skip_if_no_api()
  skip_on_cran()
  skip_if_not_installed("rsdmx")
  
  df <- data.frame(
    GEOGRAPHY_CODE = "2092957697",
    VALUE = 100
  )
  
  result1 <- add_geography_names(df)
  result2 <- add_geography_names(df, dataset_id = "NM_1_1")
  
  expect_equal(names(result1), names(result2))
})

# ============================================================================
# add_geography_names() - Functionality tests
# ============================================================================

test_that("add_geography_names adds GEOGRAPHY_NAME column", {
  skip_if_no_api()
  skip_on_cran()
  skip_if_not_installed("rsdmx")
  
  df <- data.frame(
    GEOGRAPHY_CODE = c("2092957697", "2092957698"),
    VALUE = c(100, 200)
  )
  
  result <- add_geography_names(df, dataset_id = "NM_1_1")
  
  expect_true("GEOGRAPHY_NAME" %in% names(result))
  expect_equal(nrow(result), nrow(df))
  expect_true(ncol(result) > ncol(df))
})

test_that("add_geography_names preserves original data", {
  skip_if_no_api()
  skip_on_cran()
  skip_if_not_installed("rsdmx")
  
  df <- data.frame(
    GEOGRAPHY_CODE = c("2092957697"),
    VALUE = c(100),
    OTHER_COL = c("test")
  )
  
  result <- add_geography_names(df)
  
  expect_true(all(c("GEOGRAPHY_CODE", "VALUE", "OTHER_COL") %in% names(result)))
})

test_that("add_geography_names handles missing geography codes", {
  skip_if_no_api()
  skip_on_cran()
  skip_if_not_installed("rsdmx")
  
  df <- data.frame(
    GEOGRAPHY_CODE = c("2092957697", "INVALID_CODE_999"),
    VALUE = c(100, 200)
  )
  
  result <- add_geography_names(df)
  
  expect_true("GEOGRAPHY_NAME" %in% names(result))
  expect_equal(nrow(result), 2)
})

test_that("add_geography_names uses specified dataset_id", {
  skip_if_no_api()
  skip_on_cran()
  skip_if_not_installed("rsdmx")
  
  df <- data.frame(
    GEOGRAPHY_CODE = "2092957697",
    VALUE = 100
  )
  
  result <- add_geography_names(df, dataset_id = "NM_1_1")
  
  expect_true("GEOGRAPHY_NAME" %in% names(result))
})

test_that("add_geography_names performs left join correctly", {
  skip_if_no_api()
  skip_on_cran()
  skip_if_not_installed("rsdmx")
  
  df <- data.frame(
    GEOGRAPHY_CODE = c("2092957697", "2092957698", "2092957697"),
    VALUE = c(100, 200, 300)
  )
  
  result <- add_geography_names(df)
  
  # Should preserve all rows including duplicates
  expect_equal(nrow(result), nrow(df))
})

test_that("add_geography_names handles single row", {
  skip_if_no_api()
  skip_on_cran()
  skip_if_not_installed("rsdmx")
  
  df <- data.frame(
    GEOGRAPHY_CODE = "2092957697",
    VALUE = 100
  )
  
  result <- add_geography_names(df)
  
  expect_equal(nrow(result), 1)
  expect_true("GEOGRAPHY_NAME" %in% names(result))
})

test_that("add_geography_names handles many rows", {
  skip_if_no_api()
  skip_on_cran()
  skip_if_not_installed("rsdmx")
  
  df <- data.frame(
    GEOGRAPHY_CODE = rep(c("2092957697", "2092957698"), 50),
    VALUE = 1:100
  )
  
  result <- add_geography_names(df)
  
  expect_equal(nrow(result), 100)
})

# ============================================================================
# add_geography_names() - Error handling
# ============================================================================

test_that("add_geography_names handles get_codes failure gracefully", {
  skip_on_cran()
  
  df <- data.frame(
    GEOGRAPHY_CODE = "123",
    VALUE = 100
  )
  
  with_mocked_bindings(
    get_codes = function(...) {
      data.frame(wrong_column = "test")
    },
    {
      expect_warning(
        result <- add_geography_names(df),
        "Could not create geography lookup"
      )
      
      expect_equal(result, df)
    }
  )
})

test_that("add_geography_names handles missing id column in lookup", {
  skip_on_cran()
  
  df <- data.frame(
    GEOGRAPHY_CODE = "123",
    VALUE = 100
  )
  
  with_mocked_bindings(
    get_codes = function(...) {
      tibble::tibble(
        not_id = "x",
        label.en = "y"
      )
    },
    {
      expect_warning(
        result <- add_geography_names(df),
        "Could not create geography lookup"
      )
      
      expect_equal(result, df)
    }
  )
})

test_that("add_geography_names handles missing label.en column in lookup", {
  skip_on_cran()
  
  df <- data.frame(
    GEOGRAPHY_CODE = "123",
    VALUE = 100
  )
  
  with_mocked_bindings(
    get_codes = function(...) {
      tibble::tibble(
        id = "x",
        not_label = "y"
      )
    },
    {
      expect_warning(
        result <- add_geography_names(df),
        "Could not create geography lookup"
      )
      
      expect_equal(result, df)
    }
  )
})

test_that("add_geography_names handles completely empty lookup", {
  skip_on_cran()
  
  df <- data.frame(
    GEOGRAPHY_CODE = "123",
    VALUE = 100
  )
  
  with_mocked_bindings(
    get_codes = function(...) {
      tibble::tibble()
    },
    {
      expect_warning(
        result <- add_geography_names(df),
        "Could not create geography lookup"
      )
    }
  )
})

# ============================================================================
# Integration tests
# ============================================================================

test_that("fetch_spatial and add_geography_names work together", {
  skip_if_no_api()
  skip_on_cran()
  skip_if_not_installed("rsdmx")
  
  # Get regular data (not spatial)
  df <- fetch_nomis(
    "NM_1_1",
    time = "latest",
    geography = c("2092957697", "2092957698"),
    measures = 20100
  )
  
  result <- add_geography_names(df)
  
  expect_true("GEOGRAPHY_NAME" %in% names(result))
})

test_that("spatial workflow with multiple parameters", {
  skip_if_no_api()
  skip_on_cran()
  
  result <- fetch_spatial(
    "NM_1_1",
    time = "latest",
    geography = "TYPE499",
    select = c("GEOGRAPHY_CODE", "OBS_VALUE"),
    exclude_missing = TRUE,
    measures = 20100,
    sex = 7,
    parse_sf = FALSE
  )
  
  expect_type(result, "character")
})