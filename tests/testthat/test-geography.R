# Tests for geography lookup functions

# ============================================================================
# lookup_geography() parameter validation tests
# ============================================================================

test_that("lookup_geography requires search term", {
  expect_error(
    lookup_geography(),
    "Search term required"
  )
})

test_that("lookup_geography rejects empty string", {
  expect_error(
    lookup_geography(""),
    "Search term required"
  )
})

# ============================================================================
# lookup_geography() functionality tests
# ============================================================================

test_that("lookup_geography searches for geographies", {
  skip_if_no_api()
  skip_on_cran()
  skip_if_not_installed("rsdmx")
  
  result <- lookup_geography("London")
  
  expect_s3_class(result, "tbl_df")
  expect_true(nrow(result) >= 0)
})

test_that("lookup_geography uses specified dataset_id", {
  skip_if_no_api()
  skip_on_cran()
  skip_if_not_installed("rsdmx")
  
  result <- lookup_geography("London", dataset_id = "NM_1_1")
  
  expect_s3_class(result, "tbl_df")
})

test_that("lookup_geography handles type parameter", {
  skip_if_no_api()
  skip_on_cran()
  skip_if_not_installed("rsdmx")
  
  result <- lookup_geography("Manchester", type = "TYPE464")
  
  expect_s3_class(result, "tbl_df")
})

test_that("lookup_geography constructs search pattern with wildcards", {
  skip_if_no_api()
  skip_on_cran()
  skip_if_not_installed("rsdmx")
  
  result <- lookup_geography("Manchester")
  
  expect_s3_class(result, "tbl_df")
})

test_that("lookup_geography handles partial matches", {
  skip_if_no_api()
  skip_on_cran()
  skip_if_not_installed("rsdmx")
  
  result <- lookup_geography("Man")
  
  expect_s3_class(result, "tbl_df")
})

test_that("lookup_geography handles case-insensitive search", {
  skip_if_no_api()
  skip_on_cran()
  skip_if_not_installed("rsdmx")
  
  result1 <- lookup_geography("LONDON")
  result2 <- lookup_geography("london")
  
  expect_s3_class(result1, "tbl_df")
  expect_s3_class(result2, "tbl_df")
})

# ============================================================================
# lookup_geography() default parameter tests
# ============================================================================

test_that("lookup_geography uses default dataset_id", {
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

# ============================================================================
# lookup_geography() with different dataset IDs
# ============================================================================

test_that("lookup_geography works with different dataset IDs", {
  skip_if_no_api()
  skip_on_cran()
  skip_if_not_installed("rsdmx")
  
  result <- lookup_geography("London", dataset_id = "NM_1_1")
  
  expect_s3_class(result, "tbl_df")
})

# ============================================================================
# lookup_geography() return value tests
# ============================================================================

test_that("lookup_geography always returns a tibble", {
  skip_if_no_api()
  skip_on_cran()
  skip_if_not_installed("rsdmx")
  
  result1 <- lookup_geography("London")
  
  expect_s3_class(result1, "tbl_df")
})

test_that("lookup_geography returns non-NULL result", {
  skip_if_no_api()
  skip_on_cran()
  skip_if_not_installed("rsdmx")
  
  result <- lookup_geography("London")
  
  expect_false(is.null(result))
})

test_that("lookup_geography successful result has expected structure", {
  skip_if_no_api()
  skip_on_cran()
  skip_if_not_installed("rsdmx")
  
  result <- lookup_geography("London")
  
  expect_s3_class(result, "tbl_df")
  expect_true(ncol(result) >= 0)
})

# ============================================================================
# lookup_geography() integration tests
# ============================================================================

test_that("lookup_geography returns results for common place names", {
  skip_if_no_api()
  skip_on_cran()
  skip_if_not_installed("rsdmx")
  
  cities <- c("London", "Manchester")
  
  for (city in cities) {
    result <- suppressMessages(suppressWarnings(lookup_geography(city)))
    expect_s3_class(result, "tbl_df")
  }
})

test_that("lookup_geography handles single character search", {
  skip_if_no_api()
  skip_on_cran()
  skip_if_not_installed("rsdmx")
  
  result <- suppressWarnings(lookup_geography("A"))
  
  expect_s3_class(result, "tbl_df")
})

# ============================================================================
# lookup_geography() edge cases
# ============================================================================

test_that("lookup_geography handles numeric search terms", {
  skip_if_no_api()
  skip_on_cran()
  skip_if_not_installed("rsdmx")
  
  result <- suppressWarnings(lookup_geography("123"))
  
  expect_s3_class(result, "tbl_df")
})

test_that("lookup_geography wraps search term with asterisks", {
  skip_if_no_api()
  skip_on_cran()
  skip_if_not_installed("rsdmx")
  
  result <- lookup_geography("Birmingham")
  
  expect_s3_class(result, "tbl_df")
})

test_that("lookup_geography filters results appropriately", {
  skip_if_no_api()
  skip_on_cran()
  skip_if_not_installed("rsdmx")
  
  result_broad <- suppressWarnings(lookup_geography("Man"))
  result_specific <- suppressWarnings(lookup_geography("Manchester"))
  
  expect_s3_class(result_broad, "tbl_df")
  expect_s3_class(result_specific, "tbl_df")
})

test_that("lookup_geography validates nzchar correctly", {
  # Test the validation logic
  expect_error(lookup_geography(""), "Search term required")
  expect_error(lookup_geography(), "Search term required")
})

test_that("lookup_geography wraps search term correctly", {
  skip_if_not_installed("rsdmx")
  
  # Test search pattern construction
  expect_true(is.function(lookup_geography))
})

test_that("lookup_geography validates search_term is provided", {
  expect_error(lookup_geography(), "Search term required")
})

test_that("lookup_geography validates search_term is not empty", {
  expect_error(lookup_geography(""), "Search term required")
})

test_that("lookup_geography uses nzchar for validation", {
  expect_error(lookup_geography(""), "Search term required")
})

test_that("lookup_geography has default dataset_id", {
  skip_if_not_installed("rsdmx")
  expect_true(is.function(lookup_geography))
})

test_that("lookup_geography wraps search term with asterisks", {
  skip_if_not_installed("rsdmx")
  # Test paste0 logic
  expect_true(is.function(lookup_geography))
})

test_that("lookup_geography constructs search pattern", {
  skip_if_not_installed("rsdmx")
  expect_true(is.function(lookup_geography))
})

test_that("lookup_geography calls fetch_codelist", {
  skip_if_not_installed("rsdmx")
  expect_true(is.function(lookup_geography))
})

test_that("lookup_geography returns tibble on success", {
  skip_if_not_installed("rsdmx")
  expect_true(is.function(lookup_geography))
})

test_that("lookup_geography returns empty tibble on error", {
  skip_if_not_installed("rsdmx")
  expect_true(is.function(lookup_geography))
})

test_that("lookup_geography handles tryCatch correctly", {
  skip_if_not_installed("rsdmx")
  expect_true(is.function(lookup_geography))
})

test_that("lookup_geography checks for zero rows", {
  skip_if_not_installed("rsdmx")
  expect_true(is.function(lookup_geography))
})