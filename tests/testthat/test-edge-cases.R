# Tests for edge cases and boundary conditions

test_that("fetch_nomis handles empty results", {
  skip_if_no_api()
  skip_on_cran()
  
  # Try to fetch with impossible combination
  # This should either return empty or error gracefully
  expect_error({
    fetch_nomis(
      "NM_1_1",
      time = "1900-01",  # Very old date, likely no data
      geography = "TYPE499",
      measures = 20100
    )
  }, NA)  # Should not throw unexpected error
})

test_that("functions handle very long parameter lists", {
  # Test with many geographies
  many_geographies <- rep("2092957697", 50)
  
  params <- build_params(
    id = "NM_1_1",
    time = "latest",
    date = NULL,
    geography = many_geographies,
    sex = NULL,
    measures = NULL,
    exclude_missing = FALSE,
    select = NULL
  )
  
  expect_type(params$geography, "character")
  expect_true(nchar(params$geography) > 100)
})

test_that("package handles special characters in search", {
  skip_if_no_api()
  skip_on_cran()
  
  # Should handle without erroring
  expect_error(
    search_datasets(name = "test*&special"),
    NA
  )
})