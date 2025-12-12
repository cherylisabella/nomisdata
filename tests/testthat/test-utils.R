# check_installed()
test_that("check_installed passes for installed package", {
  result <- check_installed("base")
  expect_true(result)
})

test_that("check_installed errors for missing package", {
  expect_error(
    check_installed("nonexistentpackage99999"),
    "Package 'nonexistentpackage99999' required"
  )
})

test_that("check_installed includes purpose in error message", {
  expect_error(
    check_installed("nonexistentpackage99999", purpose = "testing"),
    "required for testing"
  )
})

test_that("check_installed has correct error class", {
  err <- tryCatch(
    check_installed("nonexistentpackage99999"),
    error = function(e) e
  )
  
  expect_s3_class(err, "nomisdata_missing_package")
})

# format_number()
test_that("format_number formats large numbers", {
  result <- format_number(1000000)
  expect_type(result, "character")
  expect_match(result, "1,000,000|1.000.000")  # Handles different locales
})

test_that("format_number handles small numbers", {
  result <- format_number(123)
  expect_type(result, "character")
})

test_that("format_number avoids scientific notation", {
  result <- format_number(1e6)
  expect_false(grepl("e", tolower(result)))
})

# get_cache_key()
test_that("get_cache_key produces consistent results", {
  key1 <- get_cache_key("NM_1_1", list(time = "latest", geo = "TYPE499"))
  key2 <- get_cache_key("NM_1_1", list(time = "latest", geo = "TYPE499"))
  
  expect_equal(key1, key2)
})

test_that("get_cache_key produces different keys for different inputs", {
  key1 <- get_cache_key("NM_1_1", list(time = "latest"))
  key2 <- get_cache_key("NM_1_1", list(time = "prevyear"))
  
  expect_false(key1 == key2)
})

test_that("get_cache_key handles empty params", {
  key <- get_cache_key("NM_1_1", list())
  
  expect_type(key, "character")
  expect_true(nchar(key) > 0)
})

test_that("get_cache_key includes dataset id", {
  key1 <- get_cache_key("NM_1_1", list(time = "latest"))
  key2 <- get_cache_key("NM_2_1", list(time = "latest"))
  
  expect_false(key1 == key2)
})

test_that("get_cache_key handles multiple params", {
  key <- get_cache_key("NM_1_1", list(
    time = "latest", 
    geo = "TYPE499", 
    measures = "20100"
  ))
  
  expect_type(key, "character")
  expect_true(nchar(key) > 0)
})

test_that("get_cache_key handles special characters in params", {
  key <- get_cache_key("NM_1_1", list(
    search = "*london*",
    geo = "TYPE499"
  ))
  
  expect_type(key, "character")
})