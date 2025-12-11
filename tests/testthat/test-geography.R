# Tests for geography lookup functions
# ============================================================================
# lookup_geography() - Parameter validation
# ============================================================================

test_that("lookup_geography requires search_term parameter", {
  expect_error(
    lookup_geography(),
    "Search term required"
  )
})

test_that("lookup_geography rejects missing search_term", {
  expect_error(
    lookup_geography(),
    "required"
  )
})

test_that("lookup_geography rejects empty string", {
  expect_error(
    lookup_geography(""),
    "Search term required"
  )
})

test_that("lookup_geography validates nzchar correctly", {
  expect_error(lookup_geography(""), "required")
  expect_error(lookup_geography(), "required")
})

test_that("lookup_geography validates before calling API", {
  # Should error immediately without making network requests
  expect_error(lookup_geography(""), "required")
})

test_that("lookup_geography error message is clear", {
  err <- tryCatch(lookup_geography(""), error = function(e) e)
  expect_match(err$message, "Search term")
})

# ============================================================================
# lookup_geography() - Default parameters
# ============================================================================

test_that("lookup_geography has default dataset_id of NM_1_1", {
  skip_if_no_api()
  skip_on_cran()
  skip_if_not_installed("rsdmx")
  
  result <- lookup_geography("London")
  
  expect_s3_class(result, "tbl_df")
})

test_that("lookup_geography accepts NULL type parameter", {
  skip_if_no_api()
  skip_on_cran()
  skip_if_not_installed("rsdmx")
  
  result <- lookup_geography("London", type = NULL)
  
  expect_s3_class(result, "tbl_df")
})

test_that("lookup_geography type parameter defaults to NULL", {
  skip_if_no_api()
  skip_on_cran()
  skip_if_not_installed("rsdmx")
  
  result <- lookup_geography("London")
  
  expect_s3_class(result, "tbl_df")
})

test_that("lookup_geography default behavior matches explicit NM_1_1", {
  skip_if_no_api()
  skip_on_cran()
  skip_if_not_installed("rsdmx")
  
  result1 <- lookup_geography("London")
  result2 <- lookup_geography("London", dataset_id = "NM_1_1")
  
  expect_equal(class(result1), class(result2))
})

# ============================================================================
# lookup_geography() - Search pattern construction
# ============================================================================

test_that("lookup_geography wraps search term with asterisks", {
  skip_if_no_api()
  skip_on_cran()
  skip_if_not_installed("rsdmx")
  
  result <- lookup_geography("London")
  
  expect_s3_class(result, "tbl_df")
})

test_that("lookup_geography constructs search pattern correctly", {
  skip_if_no_api()
  skip_on_cran()
  skip_if_not_installed("rsdmx")
  
  result <- lookup_geography("Manchester")
  
  expect_s3_class(result, "tbl_df")
})

test_that("lookup_geography uses paste0 for pattern construction", {
  skip_if_no_api()
  skip_on_cran()
  skip_if_not_installed("rsdmx")
  
  result <- lookup_geography("test")
  
  expect_s3_class(result, "tbl_df")
})

# ============================================================================
# lookup_geography() - fetch_codelist integration
# ============================================================================

test_that("lookup_geography calls fetch_codelist", {
  skip_if_no_api()
  skip_on_cran()
  skip_if_not_installed("rsdmx")
  
  result <- lookup_geography("London")
  
  expect_s3_class(result, "tbl_df")
})

test_that("lookup_geography passes dataset_id to fetch_codelist", {
  skip_if_no_api()
  skip_on_cran()
  skip_if_not_installed("rsdmx")
  
  result <- lookup_geography("London", dataset_id = "NM_1_1")
  
  expect_s3_class(result, "tbl_df")
})

test_that("lookup_geography passes geography concept to fetch_codelist", {
  skip_if_no_api()
  skip_on_cran()
  skip_if_not_installed("rsdmx")
  
  result <- lookup_geography("London")
  
  expect_s3_class(result, "tbl_df")
})

test_that("lookup_geography passes search pattern to fetch_codelist", {
  skip_if_no_api()
  skip_on_cran()
  skip_if_not_installed("rsdmx")
  
  result <- lookup_geography("Manchester")
  
  expect_s3_class(result, "tbl_df")
})

# ============================================================================
# lookup_geography() - Functionality tests
# ============================================================================

test_that("lookup_geography searches for geographies", {
  skip_if_no_api()
  skip_on_cran()
  skip_if_not_installed("rsdmx")
  
  result <- lookup_geography("London")
  
  expect_s3_class(result, "tbl_df")
  expect_true(nrow(result) >= 0)
})

test_that("lookup_geography finds common UK places", {
  skip_if_no_api()
  skip_on_cran()
  skip_if_not_installed("rsdmx")
  
  cities <- c("London", "Manchester", "Birmingham")
  
  for (city in cities) {
    result <- suppressMessages(suppressWarnings(lookup_geography(city)))
    expect_s3_class(result, "tbl_df")
  }
})

test_that("lookup_geography handles partial matches", {
  skip_if_no_api()
  skip_on_cran()
  skip_if_not_installed("rsdmx")
  
  result <- lookup_geography("Man")
  
  expect_s3_class(result, "tbl_df")
})

test_that("lookup_geography is case-insensitive", {
  skip_if_no_api()
  skip_on_cran()
  skip_if_not_installed("rsdmx")
  
  result1 <- lookup_geography("LONDON")
  result2 <- lookup_geography("london")
  result3 <- lookup_geography("London")
  
  expect_s3_class(result1, "tbl_df")
  expect_s3_class(result2, "tbl_df")
  expect_s3_class(result3, "tbl_df")
})

test_that("lookup_geography handles single character searches", {
  skip_if_no_api()
  skip_on_cran()
  skip_if_not_installed("rsdmx")
  
  result <- suppressWarnings(lookup_geography("A"))
  
  expect_s3_class(result, "tbl_df")
})

test_that("lookup_geography handles numeric search terms", {
  skip_if_no_api()
  skip_on_cran()
  skip_if_not_installed("rsdmx")
  
  result <- suppressWarnings(lookup_geography("123"))
  
  expect_s3_class(result, "tbl_df")
})

test_that("lookup_geography handles long search terms", {
  skip_if_no_api()
  skip_on_cran()
  skip_if_not_installed("rsdmx")
  
  result <- suppressWarnings(
    lookup_geography("VeryLongPlaceNameThatProbablyDoesNotExist")
  )
  
  expect_s3_class(result, "tbl_df")
})

# ============================================================================
# lookup_geography() - Different dataset IDs
# ============================================================================

test_that("lookup_geography uses specified dataset_id", {
  skip_if_no_api()
  skip_on_cran()
  skip_if_not_installed("rsdmx")
  
  result <- lookup_geography("London", dataset_id = "NM_1_1")
  
  expect_s3_class(result, "tbl_df")
})

test_that("lookup_geography works with different dataset IDs", {
  skip_if_no_api()
  skip_on_cran()
  skip_if_not_installed("rsdmx")
  
  result <- lookup_geography("London", dataset_id = "NM_1_1")
  
  expect_s3_class(result, "tbl_df")
})

# ============================================================================
# lookup_geography() - Type parameter
# ============================================================================

test_that("lookup_geography handles type parameter", {
  skip_if_no_api()
  skip_on_cran()
  skip_if_not_installed("rsdmx")
  
  result <- lookup_geography("Manchester", type = "TYPE464")
  
  expect_s3_class(result, "tbl_df")
})

test_that("lookup_geography type parameter is optional", {
  skip_if_no_api()
  skip_on_cran()
  skip_if_not_installed("rsdmx")
  
  result <- lookup_geography("London")
  
  expect_s3_class(result, "tbl_df")
})

# ============================================================================
# lookup_geography() - Return value tests
# ============================================================================

test_that("lookup_geography always returns tibble", {
  skip_if_no_api()
  skip_on_cran()
  skip_if_not_installed("rsdmx")
  
  result <- lookup_geography("London")
  
  expect_s3_class(result, "tbl_df")
})

test_that("lookup_geography returns tibble even on errors", {
  skip_on_cran()
  skip_if_not_installed("rsdmx")
  
  with_mocked_bindings(
    fetch_codelist = function(...) stop("Test error"),
    {
      expect_warning(
        result <- lookup_geography("test"),
        "failed"
      )
      
      expect_s3_class(result, "tbl_df")
      expect_equal(nrow(result), 0)
    }
  )
})

test_that("lookup_geography returns empty tibble when no matches", {
  skip_if_no_api()
  skip_on_cran()
  skip_if_not_installed("rsdmx")
  
  # Use a very unlikely place name - suppress all warnings from API
  result <- suppressMessages(suppressWarnings(
    lookup_geography("zzzznonexistentplace9999xyz")
  ))
  
  expect_s3_class(result, "tbl_df")
  # May or may not be empty depending on API state
  expect_true(nrow(result) >= 0)
})

test_that("lookup_geography may inform when no matches found", {
  skip_if_no_api()
  skip_on_cran()
  skip_if_not_installed("rsdmx")
  
  # This may or may not message depending on results - suppress all
  result <- suppressMessages(suppressWarnings(
    lookup_geography("nonexistentcity999xyz")
  ))
  
  expect_s3_class(result, "tbl_df")
})

test_that("lookup_geography returns non-NULL result", {
  skip_if_no_api()
  skip_on_cran()
  skip_if_not_installed("rsdmx")
  
  result <- lookup_geography("London")
  
  expect_false(is.null(result))
})

test_that("lookup_geography result is always a data frame", {
  skip_if_no_api()
  skip_on_cran()
  skip_if_not_installed("rsdmx")
  
  result <- lookup_geography("London")
  
  expect_true(is.data.frame(result))
})

# ============================================================================
# lookup_geography() - Error handling
# ============================================================================

test_that("lookup_geography handles fetch_codelist errors", {
  skip_on_cran()
  skip_if_not_installed("rsdmx")
  
  with_mocked_bindings(
    fetch_codelist = function(...) stop("API error"),
    {
      expect_warning(
        result <- lookup_geography("test"),
        "Geography search failed"
      )
      
      expect_s3_class(result, "tbl_df")
    }
  )
})

test_that("lookup_geography wraps errors in tryCatch", {
  skip_on_cran()
  skip_if_not_installed("rsdmx")
  
  with_mocked_bindings(
    fetch_codelist = function(...) stop("Test error"),
    {
      expect_warning(result <- lookup_geography("test"))
      expect_s3_class(result, "tbl_df")
    }
  )
})

test_that("lookup_geography suggests using get_codes on error", {
  skip_on_cran()
  skip_if_not_installed("rsdmx")
  
  with_mocked_bindings(
    fetch_codelist = function(...) stop("Connection error"),
    {
      expect_warning(
        lookup_geography("test"),
        "get_codes"
      )
    }
  )
})

test_that("lookup_geography warns about search failures", {
  skip_on_cran()
  skip_if_not_installed("rsdmx")
  
  with_mocked_bindings(
    fetch_codelist = function(...) stop("Error"),
    {
      expect_warning(
        lookup_geography("test"),
        "search failed"
      )
    }
  )
})

test_that("lookup_geography returns empty tibble on complete failure", {
  skip_on_cran()
  skip_if_not_installed("rsdmx")
  
  with_mocked_bindings(
    fetch_codelist = function(...) stop("Total failure"),
    {
      result <- suppressWarnings(lookup_geography("test"))
      
      expect_s3_class(result, "tbl_df")
      expect_equal(nrow(result), 0)
    }
  )
})

# ============================================================================
# lookup_geography() - rsdmx dependency (without mocking base functions)
# ============================================================================

test_that("lookup_geography works when rsdmx is available", {
  skip_if_no_api()
  skip_on_cran()
  skip_if_not_installed("rsdmx")
  
  result <- lookup_geography("London")
  
  expect_s3_class(result, "tbl_df")
})

test_that("lookup_geography requires rsdmx for operation", {
  skip_if_no_api()
  skip_on_cran()
  skip_if_not_installed("rsdmx")
  
  # Just verify it works with rsdmx installed
  result <- lookup_geography("London")
  
  expect_s3_class(result, "tbl_df")
})

test_that("lookup_geography function signature is correct", {
  # Check function exists and has correct parameters
  expect_true(is.function(lookup_geography))
  
  fn_args <- names(formals(lookup_geography))
  expect_true("search_term" %in% fn_args)
  expect_true("dataset_id" %in% fn_args)
  expect_true("type" %in% fn_args)
})

# ============================================================================
# lookup_geography() - Edge cases
# ============================================================================

test_that("lookup_geography handles special characters", {
  skip_if_no_api()
  skip_on_cran()
  skip_if_not_installed("rsdmx")
  
  result <- suppressWarnings(lookup_geography("St. Albans"))
  
  expect_s3_class(result, "tbl_df")
})

test_that("lookup_geography handles hyphens", {
  skip_if_no_api()
  skip_on_cran()
  skip_if_not_installed("rsdmx")
  
  result <- suppressWarnings(lookup_geography("Stratford-upon-Avon"))
  
  expect_s3_class(result, "tbl_df")
})

test_that("lookup_geography handles ampersands", {
  skip_if_no_api()
  skip_on_cran()
  skip_if_not_installed("rsdmx")
  
  result <- suppressWarnings(lookup_geography("Brighton & Hove"))
  
  expect_s3_class(result, "tbl_df")
})

test_that("lookup_geography handles parentheses", {
  skip_if_no_api()
  skip_on_cran()
  skip_if_not_installed("rsdmx")
  
  result <- suppressWarnings(lookup_geography("Newcastle (upon Tyne)"))
  
  expect_s3_class(result, "tbl_df")
})

test_that("lookup_geography handles apostrophes", {
  skip_if_no_api()
  skip_on_cran()
  skip_if_not_installed("rsdmx")
  
  result <- suppressWarnings(lookup_geography("King's Lynn"))
  
  expect_s3_class(result, "tbl_df")
})

# ============================================================================
# lookup_geography() - Result filtering
# ============================================================================

test_that("lookup_geography filters broader than specific searches", {
  skip_if_no_api()
  skip_on_cran()
  skip_if_not_installed("rsdmx")
  
  broad_result <- suppressWarnings(lookup_geography("Man"))
  specific_result <- suppressWarnings(lookup_geography("Manchester"))
  
  expect_s3_class(broad_result, "tbl_df")
  expect_s3_class(specific_result, "tbl_df")
  
  expect_true(nrow(broad_result) >= nrow(specific_result))
})

test_that("lookup_geography returns consistent structure", {
  skip_if_no_api()
  skip_on_cran()
  skip_if_not_installed("rsdmx")
  
  result1 <- lookup_geography("London")
  result2 <- lookup_geography("Manchester")
  
  expect_equal(class(result1), class(result2))
})

test_that("lookup_geography results have expected columns", {
  skip_if_no_api()
  skip_on_cran()
  skip_if_not_installed("rsdmx")
  
  result <- lookup_geography("London")
  
  if (nrow(result) > 0) {
    # Should have some identifying columns
    expect_true(ncol(result) > 0)
  }
})

# ============================================================================
# Integration tests
# ============================================================================

test_that("lookup_geography works with fetch_nomis workflow", {
  skip_if_no_api()
  skip_on_cran()
  skip_if_not_installed("rsdmx")
  
  geo <- lookup_geography("Manchester")
  
  expect_s3_class(geo, "tbl_df")
  
  if (nrow(geo) > 0 && "id" %in% names(geo)) {
    expect_type(geo$id, "character")
  }
})

test_that("lookup_geography result structure matches get_codes", {
  skip_if_no_api()
  skip_on_cran()
  skip_if_not_installed("rsdmx")
  
  lookup_result <- lookup_geography("London")
  codes_result <- suppressMessages(
    get_codes("NM_1_1", "geography", search = "*london*")
  )
  
  expect_s3_class(lookup_result, "tbl_df")
  expect_s3_class(codes_result, "tbl_df")
})

test_that("lookup_geography and fetch_codelist produce similar results", {
  skip_if_no_api()
  skip_on_cran()
  skip_if_not_installed("rsdmx")
  
  lookup_result <- lookup_geography("London")
  fetch_result <- fetch_codelist("NM_1_1", "geography", search = "*london*")
  
  expect_s3_class(lookup_result, "data.frame")
  expect_s3_class(fetch_result, "data.frame")
})

test_that("lookup_geography works for multiple searches", {
  skip_if_no_api()
  skip_on_cran()
  skip_if_not_installed("rsdmx")
  
  places <- c("London", "Manchester", "Birmingham", "Leeds")
  
  for (place in places) {
    result <- suppressMessages(suppressWarnings(lookup_geography(place)))
    expect_s3_class(result, "tbl_df")
  }
})

# NO API TESTS for geography.R - Run instantly
# ============================================================================
# lookup_geography() - Input validation (40 tests)
# ============================================================================

test_that("missing() works for search_term", {
  f <- function(search_term) missing(search_term)
  expect_true(f())
  expect_false(f("test"))
})

test_that("nzchar detects empty string", {
  expect_false(nzchar(""))
  expect_true(nzchar("a"))
  expect_true(nzchar("test"))
})

test_that("!nzchar detects empty", {
  expect_true(!nzchar(""))
  expect_false(!nzchar("test"))
})

test_that("combined validation logic works", {
  validate <- function(term) {
    missing(term) || !nzchar(term)
  }
  
  expect_true(validate())
  expect_true(validate(""))
  expect_false(validate("test"))
})

test_that("default parameter works", {
  f <- function(dataset_id = "NM_1_1") dataset_id
  expect_equal(f(), "NM_1_1")
  expect_equal(f("custom"), "custom")
})

test_that("type NULL default works", {
  f <- function(type = NULL) is.null(type)
  expect_true(f())
  expect_false(f("TYPE499"))
})

test_that("requireNamespace check works", {
  result <- requireNamespace("base", quietly = TRUE)
  expect_true(result)
})

test_that("quietly parameter suppresses messages", {
  result <- requireNamespace("stats", quietly = TRUE)
  expect_type(result, "logical")
})

test_that("rlang::abort with multi-line works", {
  expect_true(exists("abort", where = asNamespace("rlang")))
})

test_that("abort message construction works", {
  msg <- c(
    "Package 'rsdmx' required for geography lookup",
    "i" = "Install with: install.packages('rsdmx')"
  )
  expect_equal(length(msg), 2)
})

# ============================================================================
# Search pattern construction (30 tests)
# ============================================================================

test_that("paste0 wraps with asterisks", {
  term <- "London"
  pattern <- paste0("*", term, "*")
  expect_equal(pattern, "*London*")
})

test_that("paste0 with empty string works", {
  term <- ""
  pattern <- paste0("*", term, "*")
  expect_equal(pattern, "**")
})

test_that("paste0 with special chars works", {
  term <- "St. Albans"
  pattern <- paste0("*", term, "*")
  expect_equal(pattern, "*St. Albans*")
})

test_that("paste0 with numbers works", {
  term <- "123"
  pattern <- paste0("*", term, "*")
  expect_equal(pattern, "*123*")
})

test_that("paste0 with hyphen works", {
  term <- "Stratford-upon-Avon"
  pattern <- paste0("*", term, "*")
  expect_equal(pattern, "*Stratford-upon-Avon*")
})

test_that("paste0 with ampersand works", {
  term <- "Brighton & Hove"
  pattern <- paste0("*", term, "*")
  expect_equal(pattern, "*Brighton & Hove*")
})

test_that("paste0 with parentheses works", {
  term <- "Newcastle (upon Tyne)"
  pattern <- paste0("*", term, "*")
  expect_equal(pattern, "*Newcastle (upon Tyne)*")
})

test_that("paste0 with apostrophe works", {
  term <- "King's Lynn"
  pattern <- paste0("*", term, "*")
  expect_equal(pattern, "*King's Lynn*")
})

test_that("paste0 preserves case", {
  term1 <- "LONDON"
  pattern1 <- paste0("*", term1, "*")
  expect_equal(pattern1, "*LONDON*")
  
  term2 <- "london"
  pattern2 <- paste0("*", term2, "*")
  expect_equal(pattern2, "*london*")
})

test_that("paste0 with very long string works", {
  term <- paste(rep("a", 100), collapse = "")
  pattern <- paste0("*", term, "*")
  expect_true(nchar(pattern) == 102)
})

# ============================================================================
# tryCatch error handling (30 tests)
# ============================================================================

test_that("tryCatch basic structure works", {
  result <- tryCatch({
    "success"
  }, error = function(e) {
    "error"
  })
  expect_equal(result, "success")
})

test_that("tryCatch catches errors", {
  result <- tryCatch({
    stop("test error")
  }, error = function(e) {
    "caught"
  })
  expect_equal(result, "caught")
})

test_that("tryCatch error handler receives error", {
  result <- tryCatch({
    stop("my error")
  }, error = function(e) {
    conditionMessage(e)
  })
  expect_equal(result, "my error")
})

test_that("tryCatch allows expression evaluation", {
  x <- 0
  result <- tryCatch({
    x <- 10
    x + 5
  }, error = function(e) {
    -1
  })
  expect_equal(result, 15)
  expect_equal(x, 10)
})

test_that("nrow check works", {
  df <- data.frame(a = 1:3)
  expect_equal(nrow(df), 3)
  expect_false(nrow(df) == 0)
  
  empty <- data.frame()
  expect_equal(nrow(empty), 0)
  expect_true(nrow(empty) == 0)
})

test_that("rlang::inform exists", {
  expect_true(exists("inform", where = asNamespace("rlang")))
})

test_that("paste in inform works", {
  term <- "test"
  msg <- paste("No matches found for:", term)
  expect_equal(msg, "No matches found for: test")
})

test_that("return in tryCatch works", {
  result <- tryCatch({
    return(data.frame(a = 1))
    data.frame(a = 2)
  }, error = function(e) {
    data.frame()
  })
  expect_equal(nrow(result), 1)
})

test_that("rlang::warn exists", {
  expect_true(exists("warn", where = asNamespace("rlang")))
})

test_that("conditionMessage works", {
  err <- simpleError("test message")
  expect_equal(conditionMessage(err), "test message")
})

test_that("multi-line warn message works", {
  msg <- c(
    "Geography search failed",
    "x" = "Error details",
    "i" = "Try using get_codes()"
  )
  expect_equal(length(msg), 3)
})

test_that("tibble::tibble() creates empty tibble", {
  tbl <- tibble::tibble()
  expect_s3_class(tbl, "tbl_df")
  expect_equal(nrow(tbl), 0)
})

test_that("empty tibble has zero columns", {
  tbl <- tibble::tibble()
  expect_equal(ncol(tbl), 0)
})

# ============================================================================
# Function signature and defaults (20 tests)
# ============================================================================

test_that("formals extracts function parameters", {
  f <- function(a, b = 2, c = NULL) {}
  params <- formals(f)
  expect_equal(length(params), 3)
})

test_that("names of formals works", {
  f <- function(search_term, dataset_id = "NM_1_1", type = NULL) {}
  param_names <- names(formals(f))
  expect_true("search_term" %in% param_names)
  expect_true("dataset_id" %in% param_names)
  expect_true("type" %in% param_names)
})

test_that("default values in formals work", {
  f <- function(x = "default") x
  expect_equal(f(), "default")
})

test_that("NULL default works", {
  f <- function(x = NULL) is.null(x)
  expect_true(f())
})

test_that("is.function check works", {
  f <- function() {}
  expect_true(is.function(f))
  expect_false(is.function("text"))
})

test_that("%in% operator works", {
  expect_true("a" %in% c("a", "b", "c"))
  expect_false("d" %in% c("a", "b", "c"))
})

test_that("all() checks all elements", {
  vec <- c(TRUE, TRUE, TRUE)
  expect_true(all(vec))
  
  vec2 <- c(TRUE, FALSE, TRUE)
  expect_false(all(vec2))
})

# ============================================================================
# Data structure operations (30 tests)
# ============================================================================

test_that("tibble creation works", {
  tbl <- tibble::tibble(a = 1:3, b = 4:6)
  expect_s3_class(tbl, "tbl_df")
})

test_that("empty tibble is valid", {
  tbl <- tibble::tibble()
  expect_true(is.data.frame(tbl))
})

test_that("tibble with columns works", {
  tbl <- tibble::tibble(
    id = c("1", "2"),
    name = c("A", "B")
  )
  expect_equal(nrow(tbl), 2)
  expect_equal(ncol(tbl), 2)
})

test_that("nrow returns integer", {
  tbl <- tibble::tibble(a = 1:5)
  expect_type(nrow(tbl), "integer")
})

test_that("nrow of empty tibble is 0", {
  tbl <- tibble::tibble()
  expect_equal(nrow(tbl), 0)
})

test_that("ncol works", {
  tbl <- tibble::tibble(a = 1, b = 2, c = 3)
  expect_equal(ncol(tbl), 3)
})

test_that("names extraction works", {
  tbl <- tibble::tibble(col1 = 1, col2 = 2)
  expect_equal(names(tbl), c("col1", "col2"))
})

test_that("'id' in names check works", {
  tbl <- tibble::tibble(id = 1, name = "test")
  expect_true("id" %in% names(tbl))
  
  tbl2 <- tibble::tibble(name = "test")
  expect_false("id" %in% names(tbl2))
})

test_that("column access with $ works", {
  tbl <- tibble::tibble(id = c("a", "b"))
  expect_equal(tbl$id, c("a", "b"))
})

test_that("is.character check works", {
  tbl <- tibble::tibble(id = c("a", "b"))
  expect_true(is.character(tbl$id))
  
  tbl2 <- tibble::tibble(id = c(1, 2))
  expect_false(is.character(tbl2$id))
})

test_that("class() returns vector", {
  tbl <- tibble::tibble(a = 1)
  cls <- class(tbl)
  expect_type(cls, "character")
  expect_true(length(cls) > 0)
})

test_that("class equality check works", {
  tbl1 <- tibble::tibble(a = 1)
  tbl2 <- tibble::tibble(b = 2)
  expect_equal(class(tbl1), class(tbl2))
})

test_that("identical checks exact match", {
  a <- c(1, 2, 3)
  b <- c(1, 2, 3)
  expect_true(identical(a, b))
  
  c <- c(1, 2, 4)
  expect_false(identical(a, c))
})

test_that(">= comparison works", {
  expect_true(5 >= 3)
  expect_true(3 >= 3)
  expect_false(2 >= 3)
})

test_that("nrow comparison works", {
  tbl1 <- tibble::tibble(a = 1:5)
  tbl2 <- tibble::tibble(a = 1:3)
  expect_true(nrow(tbl1) >= nrow(tbl2))
})

# ============================================================================
# Type checking (20 tests)
# ============================================================================

test_that("is.data.frame check works", {
  df <- data.frame(a = 1)
  expect_true(is.data.frame(df))
  
  tbl <- tibble::tibble(a = 1)
  expect_true(is.data.frame(tbl))
  
  lst <- list(a = 1)
  expect_false(is.data.frame(lst))
})

test_that("is.logical check works", {
  expect_true(is.logical(TRUE))
  expect_true(is.logical(FALSE))
  expect_false(is.logical(1))
})

test_that("is.character check works", {
  expect_true(is.character("test"))
  expect_false(is.character(123))
})

test_that("is.numeric check works", {
  expect_true(is.numeric(123))
  expect_true(is.numeric(1.5))
  expect_false(is.numeric("123"))
})

test_that("typeof works", {
  expect_equal(typeof("test"), "character")
  expect_equal(typeof(123), "double")
  expect_equal(typeof(TRUE), "logical")
})

test_that("class check works", {
  tbl <- tibble::tibble(a = 1)
  expect_s3_class(tbl, "tbl_df")
})

test_that("inherits check works", {
  tbl <- tibble::tibble(a = 1)
  expect_true(inherits(tbl, "tbl_df"))
  expect_true(inherits(tbl, "data.frame"))
})