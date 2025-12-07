# Tests for caching functionality

test_that("enable_cache sets cache directory", {
  skip_on_cran()
  skip_if(nzchar(Sys.getenv("_R_CHECK_PACKAGE_NAME_")))
  
  temp_dir <- file.path(tempdir(), "nomisdata_test_enable")
  if (dir.exists(temp_dir)) unlink(temp_dir, recursive = TRUE)
  
  orig_cache <- getOption("nomisdata.cache_dir")
  on.exit({
    options(nomisdata.cache_dir = orig_cache)
    if (dir.exists(temp_dir)) unlink(temp_dir, recursive = TRUE)
  })
  
  enable_cache(temp_dir)
  
  expect_equal(getOption("nomisdata.cache_dir"), temp_dir)
  expect_true(dir.exists(temp_dir))
})

test_that("enable_cache creates directory if needed", {
  skip_on_cran()
  skip_if(nzchar(Sys.getenv("_R_CHECK_PACKAGE_NAME_")))
  
  temp_dir <- file.path(tempdir(), "nomisdata_test_create")
  if (dir.exists(temp_dir)) unlink(temp_dir, recursive = TRUE)
  
  orig_cache <- getOption("nomisdata.cache_dir")
  on.exit({
    options(nomisdata.cache_dir = orig_cache)
    if (dir.exists(temp_dir)) unlink(temp_dir, recursive = TRUE)
  })
  
  enable_cache(temp_dir)
  
  cache_dir <- getOption("nomisdata.cache_dir")
  expect_type(cache_dir, "character")
  expect_true(dir.exists(cache_dir))
})

test_that("clear_cache removes cache directory", {
  skip_on_cran()
  skip_if(nzchar(Sys.getenv("_R_CHECK_PACKAGE_NAME_")))
  
  temp_dir <- file.path(tempdir(), "nomisdata_test_clear")
  if (dir.exists(temp_dir)) unlink(temp_dir, recursive = TRUE)
  dir.create(temp_dir, recursive = TRUE)
  
  orig_cache <- getOption("nomisdata.cache_dir")
  on.exit({
    options(nomisdata.cache_dir = orig_cache)
    if (dir.exists(temp_dir)) unlink(temp_dir, recursive = TRUE)
  })
  
  options(nomisdata.cache_dir = temp_dir)
  clear_cache()
  
  expect_false(dir.exists(temp_dir))
})

test_that("cache_data and get_cached_data work together", {
  skip_on_cran()
  skip_if(nzchar(Sys.getenv("_R_CHECK_PACKAGE_NAME_")))
  
  temp_dir <- file.path(tempdir(), "nomisdata_test_cache_ops")
  if (dir.exists(temp_dir)) unlink(temp_dir, recursive = TRUE)
  dir.create(temp_dir, recursive = TRUE, showWarnings = FALSE)
  
  orig_cache <- getOption("nomisdata.cache_dir")
  on.exit({
    options(nomisdata.cache_dir = orig_cache)
    if (dir.exists(temp_dir)) unlink(temp_dir, recursive = TRUE)
  })
  
  options(nomisdata.cache_dir = temp_dir)
  
  cache_key <- "test_key_123"
  test_data <- data.frame(x = 1:3, y = letters[1:3])
  
  cache_data(cache_key, test_data)
  retrieved <- get_cached_data(cache_key)
  
  expect_equal(retrieved, test_data)
})

test_that("get_cached_data respects max_age", {
  skip_on_cran()
  skip_if(nzchar(Sys.getenv("_R_CHECK_PACKAGE_NAME_")))
  
  temp_dir <- file.path(tempdir(), "nomisdata_test_maxage")
  if (dir.exists(temp_dir)) unlink(temp_dir, recursive = TRUE)
  dir.create(temp_dir, recursive = TRUE, showWarnings = FALSE)
  
  orig_cache <- getOption("nomisdata.cache_dir")
  on.exit({
    options(nomisdata.cache_dir = orig_cache)
    if (dir.exists(temp_dir)) unlink(temp_dir, recursive = TRUE)
  })
  
  options(nomisdata.cache_dir = temp_dir)
  
  cache_key <- "old_data"
  test_data <- data.frame(x = 1)
  
  cache_data(cache_key, test_data)
  
  expect_equal(get_cached_data(cache_key, max_age = 3600), test_data)
  expect_null(get_cached_data(cache_key, max_age = 0))
})

test_that("get_nomis_cache_dir returns path during checks", {
  cache_path <- get_nomis_cache_dir()
  
  expect_type(cache_path, "character")
  expect_true(nchar(cache_path) > 0)
})

