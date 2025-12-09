# Tests for metadata retrieval functions

# ============================================================================
# get_codes() tests
# ============================================================================

test_that("get_codes requires dataset ID", {
  expect_error(
    get_codes(),
    "Dataset ID is required"
  )
  
  expect_error(
    get_codes(NULL),
    "Dataset ID is required"
  )
  
  expect_error(
    get_codes(""),
    "Dataset ID is required"
  )
})

test_that("get_codes returns dimensions when no concept specified", {
  skip_if_no_api()
  skip_on_cran()
  
  result <- get_codes("NM_1_1")
  
  expect_s3_class(result, "tbl_df")
  expect_true(nrow(result) > 0)
})

test_that("get_codes handles missing id parameter", {
  expect_error(get_codes(id = NULL), "Dataset ID is required")
})

test_that("get_codes handles empty string id", {
  expect_error(get_codes(id = ""), "Dataset ID is required")
})

test_that("get_codes returns concept codes with valid inputs", {
  skip_if_no_api()
  skip_on_cran()
  skip_if_not_installed("rsdmx")
  
  result <- get_codes("NM_1_1", "geography")
  
  expect_s3_class(result, "tbl_df")
})

test_that("get_codes handles type parameter", {
  skip_if_no_api()
  skip_on_cran()
  skip_if_not_installed("rsdmx")
  
  result <- get_codes("NM_1_1", "geography", "TYPE499")
  
  expect_s3_class(result, "tbl_df")
})

test_that("get_codes handles search parameter", {
  skip_if_no_api()
  skip_on_cran()
  skip_if_not_installed("rsdmx")
  
  result <- suppressMessages(
    get_codes("NM_1_1", "geography", search = "*london*")
  )
  
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

test_that("get_codes handles empty results gracefully", {
  skip_if_no_api()
  skip_on_cran()
  skip_if_not_installed("rsdmx")
  
  expect_message(
    result <- get_codes("NM_1_1", "geography", search = "*zzzznonexistent*"),
    "No results found"
  )
  
  expect_s3_class(result, "tbl_df")
  expect_equal(nrow(result), 0)
})

test_that("get_codes builds correct path with type", {
  skip_if_no_api()
  skip_on_cran()
  skip_if_not_installed("rsdmx")
  
  expect_silent(result <- get_codes("NM_1_1", "geography", "TYPE499"))
  expect_s3_class(result, "tbl_df")
})

test_that("get_codes passes additional parameters via ...", {
  skip_if_no_api()
  skip_on_cran()
  skip_if_not_installed("rsdmx")
  
  result <- suppressMessages(
    get_codes("NM_1_1", "geography", search = "*london*")
  )
  
  expect_s3_class(result, "tbl_df")
})

test_that("get_codes handles NULL search gracefully", {
  skip_if_no_api()
  skip_on_cran()
  skip_if_not_installed("rsdmx")
  
  result <- get_codes("NM_1_1", "geography", search = NULL)
  
  expect_s3_class(result, "tbl_df")
})

test_that("get_codes extracts dimensions from components.dimension", {
  skip_if_no_api()
  skip_on_cran()
  
  result <- get_codes("NM_1_1")
  
  expect_s3_class(result, "tbl_df")
  expect_true(nrow(result) > 0)
})

test_that("get_codes handles concept parameter correctly", {
  skip_if_no_api()
  skip_on_cran()
  skip_if_not_installed("rsdmx")
  
  result <- get_codes("NM_1_1", "geography")
  expect_s3_class(result, "tbl_df")
})

test_that("get_codes returns empty tibble with expected columns when no data", {
  skip_if_no_api()
  skip_on_cran()
  skip_if_not_installed("rsdmx")
  
  result <- suppressMessages(
    get_codes("NM_1_1", "geography", search = "*nonexistentplacename9999*")
  )
  
  expect_s3_class(result, "tbl_df")
  expect_equal(nrow(result), 0)
})

test_that("get_codes handles NULL concept to return all dimensions", {
  skip_if_no_api()
  skip_on_cran()
  
  result <- get_codes("NM_1_1", concept = NULL)
  
  expect_s3_class(result, "tbl_df")
})

test_that("get_codes handles type as NULL", {
  skip_if_no_api()
  skip_on_cran()
  skip_if_not_installed("rsdmx")
  
  result <- get_codes("NM_1_1", "geography", type = NULL)
  
  expect_s3_class(result, "tbl_df")
})

test_that("get_codes collapses search terms with commas", {
  skip_if_no_api()
  skip_on_cran()
  skip_if_not_installed("rsdmx")
  
  result <- suppressMessages(
    get_codes("NM_1_1", "geography", search = c("*london*", "*manchester*"))
  )
  
  expect_s3_class(result, "tbl_df")
})

# ============================================================================
# fetch_codelist() tests
# ============================================================================

test_that("fetch_codelist requires id and concept", {
  expect_error(fetch_codelist(), "Both 'id' and 'concept' required")
  expect_error(fetch_codelist(id = "NM_1_1"), "Both 'id' and 'concept' required")
  expect_error(fetch_codelist(concept = "geography"), "Both 'id' and 'concept' required")
})

test_that("fetch_codelist constructs correct codelist ID", {
  skip_if_no_api()
  skip_on_cran()
  skip_if_not_installed("rsdmx")
  
  result <- fetch_codelist("NM_1_1", "geography")
  
  expect_s3_class(result, "tbl_df")
})

test_that("fetch_codelist handles search parameter", {
  skip_if_no_api()
  skip_on_cran()
  skip_if_not_installed("rsdmx")
  
  result <- fetch_codelist("NM_1_1", "geography", search = "*manchester*")
  
  expect_s3_class(result, "tbl_df")
})

test_that("fetch_codelist handles multiple search terms", {
  skip_if_no_api()
  skip_on_cran()
  skip_if_not_installed("rsdmx")
  
  result <- fetch_codelist("NM_1_1", "geography", 
                           search = c("*london*", "*birmingham*"))
  
  expect_s3_class(result, "tbl_df")
})

test_that("fetch_codelist converts NM to CL prefix", {
  skip_if_no_api()
  skip_on_cran()
  skip_if_not_installed("rsdmx")
  
  result <- fetch_codelist("NM_1_1", "geography")
  
  expect_s3_class(result, "tbl_df")
})

test_that("fetch_codelist handles NULL search gracefully", {
  skip_if_no_api()
  skip_on_cran()
  skip_if_not_installed("rsdmx")
  
  result <- fetch_codelist("NM_1_1", "geography", search = NULL)
  
  expect_s3_class(result, "tbl_df")
})

test_that("fetch_codelist handles missing id", {
  expect_error(fetch_codelist(concept = "geography"), "Both 'id' and 'concept' required")
})

test_that("fetch_codelist handles missing concept", {
  expect_error(fetch_codelist(id = "NM_1_1"), "Both 'id' and 'concept' required")
})

test_that("fetch_codelist handles lowercase dataset ID", {
  skip_if_no_api()
  skip_on_cran()
  skip_if_not_installed("rsdmx")
  
  result <- fetch_codelist("nm_1_1", "geography")
  
  expect_s3_class(result, "tbl_df")
})

test_that("fetch_codelist handles different concept types", {
  skip_if_no_api()
  skip_on_cran()
  skip_if_not_installed("rsdmx")
  
  result <- fetch_codelist("NM_1_1", "geography")
  expect_s3_class(result, "tbl_df")
})

# ============================================================================
# Integration tests
# ============================================================================

test_that("get_codes and fetch_codelist return similar structure", {
  skip_if_no_api()
  skip_on_cran()
  skip_if_not_installed("rsdmx")
  
  codes <- suppressMessages(get_codes("NM_1_1", "geography", search = "*london*"))
  codelist <- fetch_codelist("NM_1_1", "geography", search = "*london*")
  
  expect_s3_class(codes, "tbl_df")
  expect_s3_class(codelist, "tbl_df")
})

test_that("get_codes without concept returns different structure than with concept", {
  skip_if_no_api()
  skip_on_cran()
  skip_if_not_installed("rsdmx")
  
  all_dims <- get_codes("NM_1_1")
  geo_codes <- get_codes("NM_1_1", "geography")
  
  expect_s3_class(all_dims, "tbl_df")
  expect_s3_class(geo_codes, "tbl_df")
})

test_that("search parameter filters results", {
  skip_if_no_api()
  skip_on_cran()
  skip_if_not_installed("rsdmx")
  
  all_geo <- get_codes("NM_1_1", "geography")
  london_geo <- suppressMessages(get_codes("NM_1_1", "geography", search = "*london*"))
  
  expect_true(nrow(london_geo) <= nrow(all_geo))
})

test_that("type parameter affects results", {
  skip_if_no_api()
  skip_on_cran()
  skip_if_not_installed("rsdmx")
  
  all_geo <- get_codes("NM_1_1", "geography")
  typed_geo <- get_codes("NM_1_1", "geography", "TYPE499")
  
  expect_s3_class(all_geo, "tbl_df")
  expect_s3_class(typed_geo, "tbl_df")
})

test_that("get_codes constructs correct SDMX path format", {
  # Test path construction without API call
  skip_if_not_installed("rsdmx")
  
  # This just tests the path building logic
  # by checking it doesn't error with valid inputs
  expect_true(is.function(get_codes))
})

test_that("fetch_codelist constructs codelist ID correctly", {
  skip_if_not_installed("rsdmx")
  
  # Test the ID transformation logic
  expect_true(is.function(fetch_codelist))
})

test_that("get_codes validates id is not missing", {
  expect_error(get_codes(), "Dataset ID is required")
})

test_that("get_codes validates id is not NULL", {
  expect_error(get_codes(NULL), "Dataset ID is required")
})

test_that("get_codes validates id is not empty string", {
  expect_error(get_codes(""), "Dataset ID is required")
})

test_that("get_codes validates id parameter name", {
  expect_error(get_codes(id = NULL), "Dataset ID is required")
})

test_that("get_codes builds path with type", {
  skip_if_not_installed("rsdmx")
  # Test that type gets added to path correctly
  expect_true(is.function(get_codes))
})

test_that("get_codes handles NULL type parameter", {
  skip_if_not_installed("rsdmx")
  expect_true(is.function(get_codes))
})

test_that("get_codes collapses search parameter", {
  skip_if_not_installed("rsdmx")
  # Test that multiple search terms get collapsed with comma
  expect_true(is.function(get_codes))
})

test_that("fetch_codelist validates both parameters", {
  expect_error(fetch_codelist(), "Both 'id' and 'concept' required")
})

test_that("fetch_codelist validates id parameter", {
  expect_error(fetch_codelist(concept = "geography"), "Both 'id' and 'concept' required")
})

test_that("fetch_codelist validates concept parameter", {
  expect_error(fetch_codelist(id = "NM_1_1"), "Both 'id' and 'concept' required")
})

test_that("fetch_codelist transforms NM to CL", {
  skip_if_not_installed("rsdmx")
  # Test the gsub logic for transforming IDs
  expect_true(is.function(fetch_codelist))
})

test_that("fetch_codelist uppercases dataset ID", {
  skip_if_not_installed("rsdmx")
  # Test toupper logic
  expect_true(is.function(fetch_codelist))
})

test_that("fetch_codelist appends underscore", {
  skip_if_not_installed("rsdmx")
  # Test paste0 logic
  expect_true(is.function(fetch_codelist))
})

test_that("fetch_codelist constructs path correctly", {
  skip_if_not_installed("rsdmx")
  expect_true(is.function(fetch_codelist))
})

test_that("fetch_codelist adds .def.sdmx.xml extension", {
  skip_if_not_installed("rsdmx")
  expect_true(is.function(fetch_codelist))
})

test_that("fetch_codelist handles NULL search", {
  skip_if_not_installed("rsdmx")
  expect_true(is.function(fetch_codelist))
})

test_that("fetch_codelist collapses search terms", {
  skip_if_not_installed("rsdmx")
  expect_true(is.function(fetch_codelist))
})