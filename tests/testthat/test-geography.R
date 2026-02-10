test_that("lookup_geography validates search_term", {
  expect_error(lookup_geography(), "Search term required")
  expect_error(lookup_geography(""), "Search term required")
})

test_that("lookup_geography wraps search with wildcards", {
  skip_if_not_installed("rsdmx")
  
  search_captured <- NULL
  
  with_mocked_bindings(
    fetch_codelist = function(id, concept, search) {
      search_captured <<- search
      tibble::tibble(id = "1", label.en = "Test")
    },
    {
      lookup_geography("London")
      expect_equal(search_captured, "*London*")
    }
  )
})

test_that("lookup_geography uses default dataset_id", {
  skip_if_not_installed("rsdmx")
  
  id_captured <- NULL
  
  with_mocked_bindings(
    fetch_codelist = function(id, ...) {
      id_captured <<- id
      tibble::tibble()
    },
    {
      suppressMessages(lookup_geography("test"))
      expect_equal(id_captured, "NM_1_1")
    }
  )
})

test_that("lookup_geography passes custom dataset_id", {
  skip_if_not_installed("rsdmx")
  
  id_captured <- NULL
  
  with_mocked_bindings(
    fetch_codelist = function(id, ...) {
      id_captured <<- id
      tibble::tibble()
    },
    {
      suppressMessages(lookup_geography("test", dataset_id = "CUSTOM"))
      expect_equal(id_captured, "CUSTOM")
    }
  )
})

test_that("lookup_geography returns matches", {
  skip_if_not_installed("rsdmx")
  
  with_mocked_bindings(
    fetch_codelist = function(...) {
      tibble::tibble(id = c("1", "2"), label.en = c("London", "Londonderry"))
    },
    {
      result <- lookup_geography("London")
      expect_equal(nrow(result), 2)
    }
  )
})

test_that("lookup_geography informs when no matches", {
  skip_if_not_installed("rsdmx")
  
  with_mocked_bindings(
    fetch_codelist = function(...) tibble::tibble(),
    {
      expect_message(
        lookup_geography("NONEXISTENT"),
        "No matches found"
      )
    }
  )
})

test_that("lookup_geography handles fetch_codelist error", {
  skip_if_not_installed("rsdmx")
  
  with_mocked_bindings(
    fetch_codelist = function(...) stop("API error"),
    {
      expect_warning(
        result <- lookup_geography("test"),
        "search failed"
      )
      expect_equal(nrow(result), 0)
    }
  )
})

test_that("lookup_geography suggests alternative on error", {
  skip_if_not_installed("rsdmx")
  
  with_mocked_bindings(
    fetch_codelist = function(...) stop("failed"),
    {
      expect_warning(
        lookup_geography("test"),
        "get_codes"
      )
    }
  )
})

test_that("lookup_geography returns empty tibble on error", {
  skip_if_not_installed("rsdmx")
  
  with_mocked_bindings(
    fetch_codelist = function(...) stop("error"),
    {
      result <- suppressWarnings(lookup_geography("test"))
      expect_s3_class(result, "tbl_df")
      expect_equal(nrow(result), 0)
    }
  )
})