test_that("get_cache_key creates deterministic hash", {
  key1 <- get_cache_key("NM_1_1", list(time = "latest", geography = "TYPE499"))
  key2 <- get_cache_key("NM_1_1", list(time = "latest", geography = "TYPE499"))
  
  expect_identical(key1, key2)
  expect_type(key1, "character")
  expect_equal(nchar(key1), 32) # MD5 hash length
})

test_that("get_cache_key produces different hashes for different inputs", {
  key1 <- get_cache_key("NM_1_1", list(time = "latest"))
  key2 <- get_cache_key("NM_1_1", list(time = "prevyear"))
  key3 <- get_cache_key("NM_2_2", list(time = "latest"))
  
  expect_false(key1 == key2)
  expect_false(key1 == key3)
  expect_false(key2 == key3)
})

test_that("get_cache_key handles empty params", {
  key <- get_cache_key("NM_1_1", list())
  
  expect_type(key, "character")
  expect_equal(nchar(key), 32)
})

test_that("cache_data stores data when cache_dir is valid", {
  skip_on_cran()
  
  cache_dir <- tempfile("nomis_test_cache")
  dir.create(cache_dir, recursive = TRUE)
  withr::defer(unlink(cache_dir, recursive = TRUE))
  
  options(nomisdata.cache_dir = cache_dir)
  withr::defer(options(nomisdata.cache_dir = NULL))
  
  test_data <- data.frame(x = 1:5, y = letters[1:5])
  cache_key <- "test_key_12345"
  
  result <- cache_data(cache_key, test_data)
  
  expect_true(file.exists(file.path(cache_dir, paste0(cache_key, ".rds"))))
  expect_true(file.exists(file.path(cache_dir, paste0(cache_key, "_meta.rds"))))
})

test_that("cache_data returns NULL when cache_dir is NULL", {
  # Save original option
  old_option <- getOption("nomisdata.cache_dir")
  withr::defer(options(nomisdata.cache_dir = old_option))
  
  # Explicitly set to NULL - this should make cache_data exit early
  options(nomisdata.cache_dir = NULL)
  
  # Mock get_nomis_cache_dir to also return NULL
  with_mocked_bindings(
    get_nomis_cache_dir = function() NULL,
    {
      test_data <- data.frame(x = 1:5)
      result <- cache_data("key", test_data)
      
      expect_null(result)
    }
  )
})

test_that("cache_data returns NULL when cache_dir doesn't exist", {
  old_option <- getOption("nomisdata.cache_dir")
  withr::defer(options(nomisdata.cache_dir = old_option))
  
  options(nomisdata.cache_dir = "/nonexistent/path/that/does/not/exist")
  
  test_data <- data.frame(x = 1:5)
  result <- cache_data("key", test_data)
  
  expect_null(result)
})

test_that("cache_data stores metadata correctly", {
  skip_on_cran()
  
  cache_dir <- tempfile("nomis_test_cache")
  dir.create(cache_dir, recursive = TRUE)
  withr::defer(unlink(cache_dir, recursive = TRUE))
  
  options(nomisdata.cache_dir = cache_dir)
  withr::defer(options(nomisdata.cache_dir = NULL))
  
  test_data <- data.frame(x = 1:10, y = 11:20)
  cache_key <- "meta_test"
  
  cache_data(cache_key, test_data)
  
  meta_file <- file.path(cache_dir, paste0(cache_key, "_meta.rds"))
  meta <- readRDS(meta_file)
  
  expect_equal(meta$rows, 10)
  expect_s3_class(meta$timestamp, "POSIXct")
  expect_true(difftime(Sys.time(), meta$timestamp, units = "secs") < 5)
})

test_that("get_cached_data retrieves stored data", {
  skip_on_cran()
  
  cache_dir <- tempfile("nomis_test_cache")
  dir.create(cache_dir, recursive = TRUE)
  withr::defer(unlink(cache_dir, recursive = TRUE))
  
  options(nomisdata.cache_dir = cache_dir)
  withr::defer(options(nomisdata.cache_dir = NULL))
  
  test_data <- data.frame(x = 1:5, y = letters[1:5])
  cache_key <- "retrieve_test"
  
  cache_data(cache_key, test_data)
  retrieved <- get_cached_data(cache_key)
  
  expect_equal(retrieved, test_data)
})

test_that("get_cached_data returns NULL for missing cache", {
  skip_on_cran()
  
  cache_dir <- tempfile("nomis_test_cache")
  dir.create(cache_dir, recursive = TRUE)
  withr::defer(unlink(cache_dir, recursive = TRUE))
  
  options(nomisdata.cache_dir = cache_dir)
  withr::defer(options(nomisdata.cache_dir = NULL))
  
  result <- get_cached_data("nonexistent_key")
  
  expect_null(result)
})

test_that("get_cached_data returns NULL when cache_dir is NULL", {
  old_option <- getOption("nomisdata.cache_dir")
  withr::defer(options(nomisdata.cache_dir = old_option))
  
  options(nomisdata.cache_dir = NULL)
  
  result <- get_cached_data("any_key")
  
  expect_null(result)
})

test_that("get_cached_data respects max_age_days", {
  skip_on_cran()
  
  cache_dir <- tempfile("nomis_test_cache")
  dir.create(cache_dir, recursive = TRUE)
  withr::defer(unlink(cache_dir, recursive = TRUE))
  
  options(nomisdata.cache_dir = cache_dir)
  withr::defer(options(nomisdata.cache_dir = NULL))
  
  test_data <- data.frame(x = 1:5)
  cache_key <- "age_test"
  
  # Store data with old timestamp
  cache_data(cache_key, test_data)
  
  # Manually modify metadata to be 31 days old
  meta_file <- file.path(cache_dir, paste0(cache_key, "_meta.rds"))
  meta <- readRDS(meta_file)
  meta$timestamp <- Sys.time() - as.difftime(31, units = "days")
  saveRDS(meta, meta_file)
  
  # Should return NULL and inform about refresh
  expect_message(
    result <- get_cached_data(cache_key, max_age_days = 30),
    "Cached data is 31 days old"
  )
  expect_null(result)
})

test_that("get_cached_data shows success message for valid cache", {
  skip_on_cran()
  
  cache_dir <- tempfile("nomis_test_cache")
  dir.create(cache_dir, recursive = TRUE)
  withr::defer(unlink(cache_dir, recursive = TRUE))
  
  options(nomisdata.cache_dir = cache_dir)
  withr::defer(options(nomisdata.cache_dir = NULL))
  
  test_data <- data.frame(x = 1:7, y = 8:14)
  cache_key <- "success_test"
  
  cache_data(cache_key, test_data)
  
  expect_message(
    result <- get_cached_data(cache_key),
    "Using cached data \\(7 rows"
  )
  expect_equal(result, test_data)
})

test_that("get_cached_data works without metadata file", {
  skip_on_cran()
  
  cache_dir <- tempfile("nomis_test_cache")
  dir.create(cache_dir, recursive = TRUE)
  withr::defer(unlink(cache_dir, recursive = TRUE))
  
  options(nomisdata.cache_dir = cache_dir)
  withr::defer(options(nomisdata.cache_dir = NULL))
  
  test_data <- data.frame(x = 1:3)
  cache_key <- "no_meta_test"
  
  # Manually save cache file without metadata
  cache_file <- file.path(cache_dir, paste0(cache_key, ".rds"))
  saveRDS(test_data, cache_file)
  
  result <- get_cached_data(cache_key)
  
  expect_equal(result, test_data)
})