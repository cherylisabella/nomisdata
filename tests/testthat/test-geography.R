# ==============================================================================
# lookup_geography()
# ==============================================================================
test_that("lookup_geography requires search_term", {
  expect_error(lookup_geography(), "Search term required")
})

test_that("lookup_geography rejects empty string", {
  expect_error(lookup_geography(""), "Search term required")
})

test_that("lookup_geography wraps search with wildcards", {
  search_captured <- NULL
  
  local_mocked_bindings(
    fetch_codelist = function(id, concept, search) {
      search_captured <<- search
      tibble::tibble(id = "test", label.en = "Test")
    }
  )
  
  result <- lookup_geography("London")
  expect_equal(search_captured, "*London*")
})

test_that("lookup_geography returns results", {
  local_mocked_bindings(
    fetch_codelist = function(...) {
      tibble::tibble(id = c("1", "2"), label.en = c("London", "City"))
    }
  )
  
  result <- lookup_geography("London")
  expect_s3_class(result, "tbl_df")
  expect_equal(nrow(result), 2)
})

test_that("lookup_geography informs when no matches", {
  local_mocked_bindings(
    fetch_codelist = function(...) tibble::tibble()
  )
  
  expect_message(lookup_geography("Nonexistent"), "No matches found")
})

test_that("lookup_geography returns empty tibble when no matches", {
  local_mocked_bindings(
    fetch_codelist = function(...) tibble::tibble()
  )
  
  result <- suppressMessages(lookup_geography("Nonexistent"))
  expect_s3_class(result, "tbl_df")
  expect_equal(nrow(result), 0)
})

test_that("lookup_geography warns on error", {
  local_mocked_bindings(
    fetch_codelist = function(...) stop("API error")
  )
  
  expect_warning(lookup_geography("London"), "Geography search failed")
})

test_that("lookup_geography includes error message", {
  local_mocked_bindings(
    fetch_codelist = function(...) stop("Connection timeout")
  )
  
  expect_warning(lookup_geography("London"), "Connection timeout")
})

test_that("lookup_geography suggests get_codes", {
  local_mocked_bindings(
    fetch_codelist = function(...) stop("Error")
  )
  
  expect_warning(lookup_geography("London"), "get_codes")
})

test_that("lookup_geography returns empty tibble on error", {
  local_mocked_bindings(
    fetch_codelist = function(...) stop("Error")
  )
  
  result <- suppressWarnings(lookup_geography("London"))
  expect_s3_class(result, "tbl_df")
  expect_equal(nrow(result), 0)
})

test_that("lookup_geography uses default dataset_id", {
  id_captured <- NULL
  
  local_mocked_bindings(
    fetch_codelist = function(id, concept, search) {
      id_captured <<- id
      tibble::tibble()
    }
  )
  
  suppressMessages(lookup_geography("London"))
  expect_equal(id_captured, "NM_1_1")
})

test_that("lookup_geography accepts custom dataset_id", {
  id_captured <- NULL
  
  local_mocked_bindings(
    fetch_codelist = function(id, concept, search) {
      id_captured <<- id
      tibble::tibble()
    }
  )
  
  suppressMessages(lookup_geography("London", dataset_id = "NM_2_1"))
  expect_equal(id_captured, "NM_2_1")
})

test_that("lookup_geography passes geography concept", {
  concept_captured <- NULL
  
  local_mocked_bindings(
    fetch_codelist = function(id, concept, search) {
      concept_captured <<- concept
      tibble::tibble()
    }
  )
  
  suppressMessages(lookup_geography("London"))
  expect_equal(concept_captured, "geography")
})