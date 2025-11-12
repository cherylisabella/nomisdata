# Tests for caching functions

test_that("enable_cache creates directory", {
  temp_dir <- tempfile()
  on.exit(unlink(temp_dir, recursive = TRUE))
  
  enable_cache(temp_dir)
  
  expect_true(dir.exists(temp_dir))
  expect_equal(getOption("nomisdata.cache_dir"), temp_dir)
})

test_that("enable_cache uses rappdirs by default", {
  skip_if_not_installed("rappdirs")
  
  orig_cache <- getOption("nomisdata.cache_dir")
  on.exit(options(nomisdata.cache_dir = orig_cache))
  
  enable_cache()
  
  cache_dir <- getOption("nomisdata.cache_dir")
  expect_type(cache_dir, "character")
  expect_true(dir.exists(cache_dir))
})

test_that("clear_cache removes cache directory", {
  temp_dir <- tempfile()
  dir.create(temp_dir)
  options(nomisdata.cache_dir = temp_dir)
  
  # Create a test file
  writeLines("test", file.path(temp_dir, "test.txt"))
  
  clear_cache()
  
  expect_false(dir.exists(temp_dir))
})

test_that("get_cache_key generates consistent keys", {
  key1 <- get_cache_key("NM_1_1", list(time = "latest", geography = "TYPE499"))
  key2 <- get_cache_key("NM_1_1", list(time = "latest", geography = "TYPE499"))
  key3 <- get_cache_key("NM_1_1", list(geography = "TYPE499", time = "latest"))
  
  expect_equal(key1, key2)
  # Note: Order might matter in actual implementation
})

test_that("cache_data and get_cached_data work together", {
  temp_dir <- tempfile()
  dir.create(temp_dir)
  options(nomisdata.cache_dir = temp_dir)
  on.exit(unlink(temp_dir, recursive = TRUE))
  
  # Cache some data
  test_data <- data.frame(x = 1:5, y = letters[1:5])
  cache_key <- "test_key_123"
  
  cache_data(cache_key, test_data)
  
  # Retrieve it
  retrieved <- get_cached_data(cache_key, max_age_days = 1)
  
  expect_equal(retrieved, test_data)
})

test_that("get_cached_data respects max_age", {
  temp_dir <- tempfile()
  dir.create(temp_dir)
  options(nomisdata.cache_dir = temp_dir)
  on.exit(unlink(temp_dir, recursive = TRUE))
  
  # Cache some data
  test_data <- data.frame(x = 1)
  cache_key <- "old_data"
  
  cache_data(cache_key, test_data)
  
  # Modify timestamp to be old
  meta_file <- file.path(temp_dir, paste0(cache_key, "_meta.rds"))
  meta <- readRDS(meta_file)
  meta$timestamp <- Sys.time() - as.difftime(100, units = "days")
  saveRDS(meta, meta_file)
  
  # Should return NULL for old data
  expect_null(get_cached_data(cache_key, max_age_days = 30))
})
