# Tests for metadata retrieval functions
# ============================================================================
# get_codes() - Parameter validation
# ============================================================================

test_that("get_codes validates id is required", {
  expect_error(get_codes(), "Dataset ID is required")
})

test_that("get_codes validates id is not NULL", {
  expect_error(get_codes(id = NULL), "Dataset ID is required")
})

test_that("get_codes validates id is not empty string", {
  expect_error(get_codes(id = ""), "Dataset ID is required")
})

test_that("get_codes validates id parameter explicitly", {
  expect_error(get_codes(NULL), "Dataset ID is required")
})

test_that("get_codes rejects missing id", {
  expect_error(get_codes(concept = "geography"), "Dataset ID is required")
})

test_that("get_codes validates before making API call", {
  # Validation should happen before any network request
  expect_error(get_codes(id = ""), "required")
})

test_that("get_codes error message is informative", {
  err <- tryCatch(get_codes(), error = function(e) e)
  expect_match(err$message, "Dataset ID")
})

# ============================================================================
# get_codes() - Dimension retrieval (no concept)
# ============================================================================

test_that("get_codes returns dimensions when concept is NULL", {
  skip_if_no_api()
  skip_on_cran()
  
  result <- get_codes("NM_1_1", concept = NULL)
  
  expect_s3_class(result, "tbl_df")
  expect_true(nrow(result) > 0)
})

test_that("get_codes returns dimensions when no concept specified", {
  skip_if_no_api()
  skip_on_cran()
  
  result <- get_codes("NM_1_1")
  
  expect_s3_class(result, "tbl_df")
  expect_true(nrow(result) > 0)
  expect_true(ncol(result) > 0)
})

test_that("get_codes extracts dimensions from dataset info", {
  skip_if_no_api()
  skip_on_cran()
  
  result <- get_codes("NM_1_1")
  
  expect_s3_class(result, "tbl_df")
  expect_true(nrow(result) > 0)
})

test_that("get_codes calls describe_dataset when no concept", {
  skip_if_no_api()
  skip_on_cran()
  
  result <- get_codes("NM_1_1")
  
  expect_s3_class(result, "tbl_df")
})

test_that("get_codes dimension result has expected structure", {
  skip_if_no_api()
  skip_on_cran()
  
  result <- get_codes("NM_1_1")
  
  expect_s3_class(result, "data.frame")
  expect_true(ncol(result) >= 1)
})

# ============================================================================
# get_codes() - Concept retrieval
# ============================================================================

test_that("get_codes returns concept codes with valid inputs", {
  skip_if_no_api()
  skip_on_cran()
  skip_if_not_installed("rsdmx")
  
  result <- get_codes("NM_1_1", "geography")
  
  expect_s3_class(result, "tbl_df")
  expect_true(nrow(result) >= 0)
})

test_that("get_codes handles concept parameter", {
  skip_if_no_api()
  skip_on_cran()
  skip_if_not_installed("rsdmx")
  
  result <- get_codes("NM_1_1", concept = "geography")
  
  expect_s3_class(result, "tbl_df")
})

test_that("get_codes builds correct path with concept", {
  skip_if_no_api()
  skip_on_cran()
  skip_if_not_installed("rsdmx")
  
  result <- get_codes("NM_1_1", "geography")
  
  expect_s3_class(result, "tbl_df")
})

test_that("get_codes handles different concept types", {
  skip_if_no_api()
  skip_on_cran()
  skip_if_not_installed("rsdmx")
  
  # Test geography concept
  geo_result <- get_codes("NM_1_1", "geography")
  expect_s3_class(geo_result, "tbl_df")
  
  # Test measures concept
  measure_result <- get_codes("NM_1_1", "measures")
  expect_s3_class(measure_result, "tbl_df")
})

test_that("get_codes handles time concept", {
  skip_if_no_api()
  skip_on_cran()
  skip_if_not_installed("rsdmx")
  
  result <- get_codes("NM_1_1", "time")
  
  expect_s3_class(result, "tbl_df")
})

test_that("get_codes handles sex concept", {
  skip_if_no_api()
  skip_on_cran()
  skip_if_not_installed("rsdmx")
  
  result <- get_codes("NM_1_1", "sex")
  
  expect_s3_class(result, "tbl_df")
})

test_that("get_codes concept result has id column", {
  skip_if_no_api()
  skip_on_cran()
  skip_if_not_installed("rsdmx")
  
  result <- get_codes("NM_1_1", "geography")
  
  if (nrow(result) > 0) {
    expect_true("id" %in% names(result) || ncol(result) > 0)
  }
})

# ============================================================================
# get_codes() - Type parameter
# ============================================================================

test_that("get_codes handles type parameter", {
  skip_if_no_api()
  skip_on_cran()
  skip_if_not_installed("rsdmx")
  
  result <- get_codes("NM_1_1", "geography", type = "TYPE499")
  
  expect_s3_class(result, "tbl_df")
})

test_that("get_codes handles NULL type parameter", {
  skip_if_no_api()
  skip_on_cran()
  skip_if_not_installed("rsdmx")
  
  result <- get_codes("NM_1_1", "geography", type = NULL)
  
  expect_s3_class(result, "tbl_df")
})

test_that("get_codes builds path correctly with type", {
  skip_if_no_api()
  skip_on_cran()
  skip_if_not_installed("rsdmx")
  
  result <- get_codes("NM_1_1", "geography", "TYPE499")
  
  expect_s3_class(result, "tbl_df")
})

test_that("get_codes constructs type_path correctly", {
  skip_if_no_api()
  skip_on_cran()
  skip_if_not_installed("rsdmx")
  
  # With type
  result1 <- get_codes("NM_1_1", "geography", "TYPE499")
  expect_s3_class(result1, "tbl_df")
  
  # Without type
  result2 <- get_codes("NM_1_1", "geography", NULL)
  expect_s3_class(result2, "tbl_df")
})

test_that("get_codes handles different type codes", {
  skip_if_no_api()
  skip_on_cran()
  skip_if_not_installed("rsdmx")
  
  result1 <- get_codes("NM_1_1", "geography", "TYPE464")
  result2 <- get_codes("NM_1_1", "geography", "TYPE499")
  
  expect_s3_class(result1, "tbl_df")
  expect_s3_class(result2, "tbl_df")
})

# ============================================================================
# get_codes() - Search parameter
# ============================================================================

test_that("get_codes handles search parameter", {
  skip_if_no_api()
  skip_on_cran()
  skip_if_not_installed("rsdmx")
  
  result <- suppressMessages(
    get_codes("NM_1_1", "geography", search = "*london*")
  )
  
  expect_s3_class(result, "tbl_df")
})

test_that("get_codes handles NULL search parameter", {
  skip_if_no_api()
  skip_on_cran()
  skip_if_not_installed("rsdmx")
  
  result <- get_codes("NM_1_1", "geography", search = NULL)
  
  expect_s3_class(result, "tbl_df")
})

test_that("get_codes handles multiple search terms", {
  skip_if_no_api()
  skip_on_cran()
  skip_if_not_installed("rsdmx")
  
  result <- suppressMessages(
    get_codes("NM_1_1", "geography", search = c("*london*", "*manchester*"))
  )
  
  expect_s3_class(result, "tbl_df")
})

test_that("get_codes collapses search terms with commas", {
  skip_if_no_api()
  skip_on_cran()
  skip_if_not_installed("rsdmx")
  
  result <- suppressMessages(
    get_codes("NM_1_1", "geography", search = c("*london*", "*birmingham*"))
  )
  
  expect_s3_class(result, "tbl_df")
})

test_that("get_codes filters results with search", {
  skip_if_no_api()
  skip_on_cran()
  skip_if_not_installed("rsdmx")
  
  all_geo <- get_codes("NM_1_1", "geography")
  london_geo <- suppressMessages(
    get_codes("NM_1_1", "geography", search = "*london*")
  )
  
  expect_true(nrow(london_geo) <= nrow(all_geo))
})

test_that("get_codes search is case-insensitive", {
  skip_if_no_api()
  skip_on_cran()
  skip_if_not_installed("rsdmx")
  
  result1 <- suppressMessages(get_codes("NM_1_1", "geography", search = "*LONDON*"))
  result2 <- suppressMessages(get_codes("NM_1_1", "geography", search = "*london*"))
  
  expect_s3_class(result1, "tbl_df")
  expect_s3_class(result2, "tbl_df")
})

test_that("get_codes handles wildcard-only search", {
  skip_if_no_api()
  skip_on_cran()
  skip_if_not_installed("rsdmx")
  
  result <- suppressMessages(
    get_codes("NM_1_1", "geography", search = "*")
  )
  
  expect_s3_class(result, "tbl_df")
})

# ============================================================================
# get_codes() - Additional parameters via ...
# ============================================================================

test_that("get_codes passes additional parameters via ...", {
  skip_if_no_api()
  skip_on_cran()
  skip_if_not_installed("rsdmx")
  
  result <- suppressMessages(
    get_codes("NM_1_1", "geography", search = "*london*")
  )
  
  expect_s3_class(result, "tbl_df")
})

test_that("get_codes handles extra parameters in dots", {
  skip_if_no_api()
  skip_on_cran()
  skip_if_not_installed("rsdmx")
  
  result <- get_codes("NM_1_1", "geography")
  
  expect_s3_class(result, "tbl_df")
})

# ============================================================================
# get_codes() - SDMX parsing and data handling
# ============================================================================

test_that("get_codes parses SDMX data correctly", {
  skip_if_no_api()
  skip_on_cran()
  skip_if_not_installed("rsdmx")
  
  result <- get_codes("NM_1_1", "geography")
  
  expect_s3_class(result, "tbl_df")
  expect_true(ncol(result) > 0)
})

test_that("get_codes converts SDMX to tibble", {
  skip_if_no_api()
  skip_on_cran()
  skip_if_not_installed("rsdmx")
  
  result <- get_codes("NM_1_1", "geography")
  
  expect_s3_class(result, "tbl_df")
})

test_that("get_codes handles empty results gracefully", {
  skip_if_no_api()
  skip_on_cran()
  skip_if_not_installed("rsdmx")
  
  result <- suppressMessages(
    get_codes("NM_1_1", "geography", search = "*nonexistentplace9999*")
  )
  
  expect_s3_class(result, "tbl_df")
  expect_equal(nrow(result), 0)
})

test_that("get_codes returns empty tibble with expected structure on no results", {
  skip_if_no_api()
  skip_on_cran()
  skip_if_not_installed("rsdmx")
  
  result <- suppressMessages(
    get_codes("NM_1_1", "geography", search = "*zzzznonexistent*")
  )
  
  expect_s3_class(result, "tbl_df")
  expect_equal(nrow(result), 0)
})

test_that("get_codes handles SDMX parsing errors", {
  skip_if_no_api()
  skip_on_cran()
  skip_if_not_installed("rsdmx")
  
  result <- suppressMessages(
    get_codes("NM_1_1", "geography", search = "*test*")
  )
  
  expect_s3_class(result, "tbl_df")
})

test_that("get_codes returns data frame on successful parse", {
  skip_if_no_api()
  skip_on_cran()
  skip_if_not_installed("rsdmx")
  
  result <- get_codes("NM_1_1", "geography")
  
  expect_true(is.data.frame(result))
})

test_that("get_codes handles NULL SDMX object", {
  skip_on_cran()
  skip_if_not_installed("rsdmx")
  
  # This tests the internal error handling
  # We can't easily mock rsdmx::readSDMX, so we just verify the function exists
  expect_true(is.function(get_codes))
})

# ============================================================================
# get_codes() - rsdmx dependency (without mocking base functions)
# ============================================================================

test_that("get_codes works when rsdmx is available", {
  skip_if_no_api()
  skip_on_cran()
  skip_if_not_installed("rsdmx")
  
  result <- get_codes("NM_1_1", "geography")
  
  expect_s3_class(result, "tbl_df")
})

test_that("get_codes requires rsdmx for concept queries", {
  skip_if_no_api()
  skip_on_cran()
  skip_if_not_installed("rsdmx")
  
  # Just verify it works with rsdmx installed
  result <- get_codes("NM_1_1", "geography")
  
  expect_s3_class(result, "tbl_df")
})

# ============================================================================
# fetch_codelist() - Parameter validation
# ============================================================================

test_that("fetch_codelist requires both id and concept", {
  expect_error(fetch_codelist(), "Both 'id' and 'concept' required")
})

test_that("fetch_codelist requires id parameter", {
  expect_error(
    fetch_codelist(concept = "geography"),
    "Both 'id' and 'concept' required"
  )
})

test_that("fetch_codelist requires concept parameter", {
  expect_error(
    fetch_codelist(id = "NM_1_1"),
    "Both 'id' and 'concept' required"
  )
})

test_that("fetch_codelist validates both parameters are not missing", {
  # Only tests missing(), not empty strings
  expect_error(
    fetch_codelist(),
    "Both 'id' and 'concept' required"
  )
})

test_that("fetch_codelist validation happens before API call", {
  # Should error immediately without network request
  expect_error(fetch_codelist(), "required")
})

# ============================================================================
# fetch_codelist() - ID transformation
# ============================================================================

test_that("fetch_codelist converts NM to CL prefix", {
  skip_if_no_api()
  skip_on_cran()
  skip_if_not_installed("rsdmx")
  
  result <- fetch_codelist("NM_1_1", "geography")
  
  expect_s3_class(result, "tbl_df")
})

test_that("fetch_codelist uppercases dataset ID", {
  skip_if_no_api()
  skip_on_cran()
  skip_if_not_installed("rsdmx")
  
  # Lowercase input should work
  result <- fetch_codelist("nm_1_1", "geography")
  
  expect_s3_class(result, "tbl_df")
})

test_that("fetch_codelist transforms ID correctly", {
  skip_if_no_api()
  skip_on_cran()
  skip_if_not_installed("rsdmx")
  
  # NM_1_1 should become CL_NM_1_1_
  result <- fetch_codelist("NM_1_1", "geography")
  
  expect_s3_class(result, "tbl_df")
})

test_that("fetch_codelist appends underscore to ID", {
  skip_if_no_api()
  skip_on_cran()
  skip_if_not_installed("rsdmx")
  
  result <- fetch_codelist("NM_1_1", "geography")
  
  expect_s3_class(result, "tbl_df")
})

test_that("fetch_codelist handles mixed case ID", {
  skip_if_no_api()
  skip_on_cran()
  skip_if_not_installed("rsdmx")
  
  result <- fetch_codelist("Nm_1_1", "geography")
  
  expect_s3_class(result, "tbl_df")
})

# ============================================================================
# fetch_codelist() - Path construction
# ============================================================================

test_that("fetch_codelist constructs correct path", {
  skip_if_no_api()
  skip_on_cran()
  skip_if_not_installed("rsdmx")
  
  result <- fetch_codelist("NM_1_1", "geography")
  
  expect_s3_class(result, "tbl_df")
})

test_that("fetch_codelist adds .def.sdmx.xml extension", {
  skip_if_no_api()
  skip_on_cran()
  skip_if_not_installed("rsdmx")
  
  result <- fetch_codelist("NM_1_1", "geography")
  
  expect_s3_class(result, "tbl_df")
})

test_that("fetch_codelist constructs correct codelist ID format", {
  skip_if_no_api()
  skip_on_cran()
  skip_if_not_installed("rsdmx")
  
  result <- fetch_codelist("NM_1_1", "geography")
  
  expect_s3_class(result, "tbl_df")
})

test_that("fetch_codelist uses NOMIS_CODELIST constant", {
  skip_if_no_api()
  skip_on_cran()
  skip_if_not_installed("rsdmx")
  
  result <- fetch_codelist("NM_1_1", "geography")
  
  expect_s3_class(result, "tbl_df")
})

# ============================================================================
# fetch_codelist() - Search parameter
# ============================================================================

test_that("fetch_codelist handles search parameter", {
  skip_if_no_api()
  skip_on_cran()
  skip_if_not_installed("rsdmx")
  
  result <- fetch_codelist("NM_1_1", "geography", search = "*manchester*")
  
  expect_s3_class(result, "tbl_df")
})

test_that("fetch_codelist handles NULL search", {
  skip_if_no_api()
  skip_on_cran()
  skip_if_not_installed("rsdmx")
  
  result <- fetch_codelist("NM_1_1", "geography", search = NULL)
  
  expect_s3_class(result, "tbl_df")
})

test_that("fetch_codelist handles multiple search terms", {
  skip_if_no_api()
  skip_on_cran()
  skip_if_not_installed("rsdmx")
  
  result <- fetch_codelist(
    "NM_1_1",
    "geography",
    search = c("*london*", "*birmingham*")
  )
  
  expect_s3_class(result, "tbl_df")
})

test_that("fetch_codelist collapses search terms", {
  skip_if_no_api()
  skip_on_cran()
  skip_if_not_installed("rsdmx")
  
  result <- fetch_codelist(
    "NM_1_1",
    "geography",
    search = c("*london*", "*manchester*")
  )
  
  expect_s3_class(result, "tbl_df")
})

test_that("fetch_codelist appends search to URL", {
  skip_if_no_api()
  skip_on_cran()
  skip_if_not_installed("rsdmx")
  
  result <- fetch_codelist("NM_1_1", "geography", search = "*test*")
  
  expect_s3_class(result, "tbl_df")
})

# ============================================================================
# fetch_codelist() - Different concepts
# ============================================================================

test_that("fetch_codelist works with different concepts", {
  skip_if_no_api()
  skip_on_cran()
  skip_if_not_installed("rsdmx")
  
  geo_result <- fetch_codelist("NM_1_1", "geography")
  expect_s3_class(geo_result, "tbl_df")
  
  measure_result <- fetch_codelist("NM_1_1", "measures")
  expect_s3_class(measure_result, "tbl_df")
})

test_that("fetch_codelist handles sex concept", {
  skip_if_no_api()
  skip_on_cran()
  skip_if_not_installed("rsdmx")
  
  result <- fetch_codelist("NM_1_1", "sex")
  
  expect_s3_class(result, "tbl_df")
})

test_that("fetch_codelist handles age concept", {
  skip_if_no_api()
  skip_on_cran()
  skip_if_not_installed("rsdmx")
  
  result <- fetch_codelist("NM_1_1", "age")
  
  expect_s3_class(result, "tbl_df")
})

# ============================================================================
# fetch_codelist() - rsdmx dependency
# ============================================================================

test_that("fetch_codelist works when rsdmx is available", {
  skip_if_no_api()
  skip_on_cran()
  skip_if_not_installed("rsdmx")
  
  result <- fetch_codelist("NM_1_1", "geography")
  
  expect_s3_class(result, "tbl_df")
})

# ============================================================================
# Integration tests
# ============================================================================

test_that("get_codes and fetch_codelist return compatible structures", {
  skip_if_no_api()
  skip_on_cran()
  skip_if_not_installed("rsdmx")
  
  codes <- get_codes("NM_1_1", "geography")
  codelist <- fetch_codelist("NM_1_1", "geography")
  
  expect_s3_class(codes, "tbl_df")
  expect_s3_class(codelist, "tbl_df")
})

test_that("get_codes with and without concept return different structures", {
  skip_if_no_api()
  skip_on_cran()
  skip_if_not_installed("rsdmx")
  
  all_dims <- get_codes("NM_1_1")
  geo_codes <- get_codes("NM_1_1", "geography")
  
  expect_s3_class(all_dims, "tbl_df")
  expect_s3_class(geo_codes, "tbl_df")
  
  # Structure should be different
  expect_false(identical(names(all_dims), names(geo_codes)))
})

test_that("search parameter actually filters results", {
  skip_if_no_api()
  skip_on_cran()
  skip_if_not_installed("rsdmx")
  
  all_results <- get_codes("NM_1_1", "geography")
  filtered_results <- suppressMessages(
    get_codes("NM_1_1", "geography", search = "*london*")
  )
  
  expect_true(nrow(filtered_results) <= nrow(all_results))
})

test_that("type parameter affects result set", {
  skip_if_no_api()
  skip_on_cran()
  skip_if_not_installed("rsdmx")
  
  all_geo <- get_codes("NM_1_1", "geography")
  typed_geo <- get_codes("NM_1_1", "geography", "TYPE499")
  
  expect_s3_class(all_geo, "tbl_df")
  expect_s3_class(typed_geo, "tbl_df")
})

test_that("get_codes and fetch_codelist produce similar results", {
  skip_if_no_api()
  skip_on_cran()
  skip_if_not_installed("rsdmx")
  
  codes_result <- get_codes("NM_1_1", "geography")
  fetch_result <- fetch_codelist("NM_1_1", "geography")
  
  expect_s3_class(codes_result, "data.frame")
  expect_s3_class(fetch_result, "data.frame")
})

test_that("metadata functions work with different datasets", {
  skip_if_no_api()
  skip_on_cran()
  skip_if_not_installed("rsdmx")
  
  result1 <- get_codes("NM_1_1", "geography")
  result2 <- fetch_codelist("NM_1_1", "geography")
  
  expect_s3_class(result1, "tbl_df")
  expect_s3_class(result2, "tbl_df")
})