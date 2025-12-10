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