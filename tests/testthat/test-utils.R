# Tests for utility functions

test_that("check_installed detects missing packages", {
  expect_error(
    check_installed("nonexistent_package_xyz"),
    "Package.*required"
  )
})

test_that("format_number formats with commas", {
  skip_if_not_installed("scales")
  
  result <- format_number(1000000)
  expect_match(result, "1,000,000")
})

test_that("format_number works without scales", {
  # Test when scales is NOT installed
  if (requireNamespace("scales", quietly = TRUE)) {
    skip("scales is installed, cannot test fallback")
  }
  
  result <- format_number(1000)
  expect_match(result, "1.*000")  # May use different separator
})
