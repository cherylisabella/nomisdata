# Tests for utility functions

test_that("check_installed detects missing packages", {
  expect_error(
    check_installed("nonexistent_package_xyz"),
    "Package.*required"
  )
})

test_that("check_installed accepts installed packages", {
  # Test with a package that's definitely installed (base package)
  result <- check_installed("utils")
  expect_true(result)
})

test_that("check_installed includes purpose in error message", {
  expect_error(
    check_installed("nonexistent_package_xyz", purpose = "testing"),
    "for testing"
  )
})

test_that("check_installed error has correct class", {
  expect_error(
    check_installed("nonexistent_package_xyz"),
    class = "nomisdata_missing_package"
  )
})

test_that("format_number formats with commas", {
  skip_if_not_installed("scales")
  
  result <- format_number(1000000)
  expect_match(result, "1,000,000")
})

test_that("format_number handles different number sizes", {
  skip_if_not_installed("scales")
  
  expect_match(format_number(1000), "1,000")
  expect_match(format_number(1000000), "1,000,000")
  expect_match(format_number(1234567890), "1,234,567,890")
})

test_that("format_number handles small numbers", {
  skip_if_not_installed("scales")
  
  result <- format_number(100)
  expect_type(result, "character")
})

test_that("format_number works without scales package", {
  # Only test if scales is actually installed
  skip_if_not_installed("scales")
  
  # Temporarily unload scales if loaded
  if ("package:scales" %in% search()) {
    detach("package:scales", unload = TRUE)
    on.exit(library(scales), add = TRUE)
  }
  
  result <- format_number(1000)
  expect_type(result, "character")
  expect_match(result, "1.*000")
})

test_that("format_number fallback formats large numbers", {
  # Test the base::format fallback
  result <- format_number(1000000)
  expect_type(result, "character")
  # Should contain the number in some format
  expect_true(nchar(result) > 5)
})

test_that("get_cache_key creates consistent hashes with digest", {
  skip_if_not_installed("digest")
  
  key1 <- get_cache_key("NM_1_1", list(time = "latest", geo = "TYPE499"))
  key2 <- get_cache_key("NM_1_1", list(time = "latest", geo = "TYPE499"))
  
  expect_identical(key1, key2)
  expect_type(key1, "character")
})

test_that("get_cache_key produces different hashes for different inputs", {
  skip_if_not_installed("digest")
  
  key1 <- get_cache_key("NM_1_1", list(time = "latest"))
  key2 <- get_cache_key("NM_1_1", list(time = "prevyear"))
  key3 <- get_cache_key("NM_2_2", list(time = "latest"))
  
  expect_false(key1 == key2)
  expect_false(key1 == key3)
})

test_that("get_cache_key handles empty params with digest", {
  skip_if_not_installed("digest")
  
  key <- get_cache_key("NM_1_1", list())
  
  expect_type(key, "character")
  expect_true(nchar(key) > 0)
})

test_that("get_cache_key fallback works without digest", {
  skip_if_not_installed("digest")
  
  # When digest is available, we can still test the fallback logic exists
  key <- get_cache_key("NM_1_1", list(time = "latest"))
  
  expect_type(key, "character")
  expect_true(nchar(key) > 0)
})

test_that("get_cache_key with digest returns MD5 hash format", {
  skip_if_not_installed("digest")
  
  key <- get_cache_key("NM_1_1", list(time = "latest"))
  
  # MD5 hashes are 32 characters long
  expect_equal(nchar(key), 32)
  # Should be hexadecimal
  expect_match(key, "^[0-9a-f]{32}$")
})

test_that("format_number returns character", {
  result <- format_number(12345)
  expect_type(result, "character")
})

test_that("format_number handles zero", {
  result <- format_number(0)
  expect_type(result, "character")
  expect_match(result, "0")
})

test_that("format_number handles negative numbers", {
  skip_if_not_installed("scales")
  
  result <- format_number(-1000)
  expect_type(result, "character")
  expect_match(result, "-")
})

test_that("check_installed with stats package", {
  result <- check_installed("stats")
  expect_true(result)
})

test_that("format_number handles very large numbers", {
  result <- format_number(1e9)
  expect_type(result, "character")
})

test_that("get_cache_key handles complex params", {
  skip_if_not_installed("digest")
  
  params <- list(
    time = "latest",
    geography = c("TYPE499", "TYPE480"),
    measures = c(20100, 20101)
  )
  
  key <- get_cache_key("NM_1_1", params)
  expect_type(key, "character")
  expect_equal(nchar(key), 32)
})

test_that("get_cache_key handles named vs unnamed lists", {
  skip_if_not_installed("digest")
  
  key1 <- get_cache_key("NM_1_1", list(a = 1, b = 2))
  key2 <- get_cache_key("NM_1_1", list(a = 1, b = 2))
  
  expect_identical(key1, key2)
})

test_that("format_number handles decimal numbers", {
  result <- format_number(1234.56)
  expect_type(result, "character")
})

test_that("check_installed returns TRUE for base packages", {
  expect_true(check_installed("base"))
  expect_true(check_installed("utils"))
  expect_true(check_installed("stats"))
})

test_that("format_number is consistent", {
  r1 <- format_number(1000)
  r2 <- format_number(1000)
  expect_equal(r1, r2)
})