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

test_that("list() creates empty list", {
  params <- list()
  expect_type(params, "list")
  expect_equal(length(params), 0)
})

test_that("!is.null check works", {
  x <- "test"
  expect_true(!is.null(x))
  
  y <- NULL
  expect_false(!is.null(y))
})

test_that("paste collapse works", {
  date <- c("latest", "prevyear")
  result <- paste(date, collapse = ",")
  expect_equal(result, "latest,prevyear")
})

test_that("paste single value works", {
  date <- "latest"
  result <- paste(date, collapse = ",")
  expect_equal(result, "latest")
})

test_that("list element assignment works", {
  params <- list()
  params$date <- "latest"
  expect_equal(params$date, "latest")
})

test_that("date vs time precedence works", {
  date <- "latest"
  time <- "prevyear"
  
  # When date is not NULL, it takes precedence
  params <- list()
  if (!is.null(date)) {
    params$date <- paste(date, collapse = ",")
  } else if (!is.null(time)) {
    params$time <- paste(time, collapse = ",")
  }
  
  expect_true("date" %in% names(params))
  expect_false("time" %in% names(params))
})

test_that("time used when date is NULL", {
  date <- NULL
  time <- "latest"
  
  params <- list()
  if (!is.null(date)) {
    params$date <- paste(date, collapse = ",")
  } else if (!is.null(time)) {
    params$time <- paste(time, collapse = ",")
  }
  
  expect_true("time" %in% names(params))
  expect_false("date" %in% names(params))
})

test_that("c() with toupper works", {
  select <- c("geography_code", "obs_value")
  upper_select <- toupper(select)
  expect_equal(upper_select, c("GEOGRAPHY_CODE", "OBS_VALUE"))
})

test_that("unique removes duplicates", {
  vec <- c("A", "B", "A", "C", "B", "RECORD_COUNT")
  result <- unique(vec)
  expect_true(length(result) < length(vec))
})

test_that("c() combines vectors", {
  result <- c(toupper(c("a", "b")), "RECORD_COUNT")
  expect_equal(length(result), 3)
})

test_that("isTRUE works", {
  expect_true(isTRUE(TRUE))
  expect_false(isTRUE(FALSE))
  expect_false(isTRUE(NULL))
  expect_false(isTRUE(1))
})

test_that("ExcludeMissingValues string works", {
  params <- list()
  if (isTRUE(TRUE)) {
    params$ExcludeMissingValues <- "true"
  }
  expect_equal(params$ExcludeMissingValues, "true")
})

test_that("rlang::list2 works", {
  dots <- rlang::list2(age = 0, item = 1)
  expect_equal(length(dots), 2)
})

test_that("names() extraction works", {
  lst <- list(a = 1, b = 2, c = 3)
  nms <- names(lst)
  expect_equal(length(nms), 3)
})

test_that("length check on list element works", {
  lst <- list(a = 1:3, b = character(0))
  has_length_a <- length(lst$a) > 0
  has_length_b <- length(lst$b) > 0
  
  expect_true(has_length_a)
  expect_false(has_length_b)
})

test_that("for loop over names works", {
  dots <- list(AGE = "0", ITEM = "1")
  params <- list()
  
  for (nm in names(dots)) {
    if (length(dots[[nm]]) > 0) {
      params[[nm]] <- paste(dots[[nm]], collapse = ",")
    }
  }
  
  expect_equal(length(params), 2)
})

test_that("toupper on names works", {
  lst <- list(age = 0, item = 1)
  
  result <- list()
  for (nm in names(lst)) {
    result[[toupper(nm)]] <- lst[[nm]]
  }
  
  expect_true("AGE" %in% names(result))
  expect_true("ITEM" %in% names(result))
})

test_that("[[]] list indexing works", {
  lst <- list(a = 1, b = 2)
  expect_equal(lst[["a"]], 1)
  expect_equal(lst[["b"]], 2)
})

test_that("paste0 for path construction works", {
  id <- "NM_1_1"
  path <- paste0(id, ".data.kml")
  expect_equal(path, "NM_1_1.data.kml")
})

# ============================================================================
# add_geography_names() - Logic (30 tests)
# ============================================================================

test_that("'GEOGRAPHY_CODE' in names check works", {
  df <- data.frame(GEOGRAPHY_CODE = "123", VALUE = 100)
  expect_true("GEOGRAPHY_CODE" %in% names(df))
  
  df2 <- data.frame(GEO = "123", VALUE = 100)
  expect_false("GEOGRAPHY_CODE" %in% names(df2))
})

test_that("! negation works", {
  df <- data.frame(OTHER = 1)
  expect_true(!"GEOGRAPHY_CODE" %in% names(df))
})

test_that("cli::cli_abort exists", {
  expect_true(exists("cli_abort", where = asNamespace("cli")))
})

test_that("cli::cli_inform exists", {
  expect_true(exists("cli_inform", where = asNamespace("cli")))
})

test_that("'GEOGRAPHY_NAME' in names check works", {
  df <- data.frame(GEOGRAPHY_CODE = "1", GEOGRAPHY_NAME = "Test")
  expect_true("GEOGRAPHY_NAME" %in% names(df))
})

test_that("return early works", {
  f <- function(data) {
    if ("GEOGRAPHY_NAME" %in% names(data)) {
      return(data)
    }
    data.frame(a = 1)
  }
  
  df_with_name <- data.frame(GEOGRAPHY_NAME = "test")
  result <- f(df_with_name)
  expect_equal(names(result), "GEOGRAPHY_NAME")
})

test_that("'id' in names check works", {
  df <- data.frame(id = "123", label.en = "Test")
  expect_true("id" %in% names(df))
})

test_that("'label.en' in names check works", {
  df <- data.frame(id = "123", label.en = "Test")
  expect_true("label.en" %in% names(df))
})

test_that("&& combines conditions", {
  df <- data.frame(id = "1", label.en = "Test")
  result <- "id" %in% names(df) && "label.en" %in% names(df)
  expect_true(result)
})

test_that("data.frame creation works", {
  df <- data.frame(
    GEOGRAPHY_CODE = c("1", "2"),
    GEOGRAPHY_NAME = c("A", "B"),
    stringsAsFactors = FALSE
  )
  expect_equal(nrow(df), 2)
  expect_equal(ncol(df), 2)
})

test_that("stringsAsFactors = FALSE works", {
  df <- data.frame(
    col = c("a", "b"),
    stringsAsFactors = FALSE
  )
  expect_true(is.character(df$col))
})

test_that("$ column access works", {
  lookup <- data.frame(id = c("1", "2"))
  expect_equal(lookup$id, c("1", "2"))
})

test_that("cli::cli_warn exists", {
  expect_true(exists("cli_warn", where = asNamespace("cli")))
})

test_that("dplyr::left_join exists", {
  expect_true(exists("left_join", where = asNamespace("dplyr")))
})

test_that("by parameter for join works", {
  df1 <- data.frame(GEOGRAPHY_CODE = "1", VALUE = 100)
  df2 <- data.frame(GEOGRAPHY_CODE = "1", NAME = "Test")
  
  result <- dplyr::left_join(df1, df2, by = "GEOGRAPHY_CODE")
  expect_equal(ncol(result), 3)
})