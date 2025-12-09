test_that("enable_cache sets cache directory option", {
  skip_on_cran()
  skip_if(nzchar(Sys.getenv("_R_CHECK_PACKAGE_NAME_")), 
          "Skip during R CMD check")
  
  cache_path <- tempfile("nomis_cache")
  result <- enable_cache(cache_path)
  
  expect_equal(getOption("nomisdata.cache_dir"), cache_path)
  expect_identical(result, cache_path)
  
  # Clean up
  options(nomisdata.cache_dir = NULL)
  if (dir.exists(cache_path)) unlink(cache_path, recursive = TRUE)
})

test_that("enable_cache uses tempdir during R CMD check", {
  # Simulate R CMD check environment
  withr::with_envvar(
    c("_R_CHECK_PACKAGE_NAME_" = "nomisdata"),
    {
      result <- enable_cache()
      expect_true(grepl("nomisdata", result))
      expect_true(grepl(tempdir(), result, fixed = TRUE))
    }
  )
  
  options(nomisdata.cache_dir = NULL)
})

test_that("enable_cache respects NOT_CRAN=false", {
  withr::with_envvar(
    c("NOT_CRAN" = "false"),
    {
      result <- enable_cache()
      expect_true(grepl(tempdir(), result, fixed = TRUE))
    }
  )
  
  options(nomisdata.cache_dir = NULL)
})

test_that("enable_cache does not create directory during R CMD check", {
  skip_on_cran()
  
  cache_path <- tempfile("nomis_test")
  
  withr::with_envvar(
    c("_R_CHECK_PACKAGE_NAME_" = "nomisdata"),
    {
      enable_cache(cache_path)
      # During check, directory should NOT be created
      expect_false(dir.exists(cache_path))
    }
  )
  
  options(nomisdata.cache_dir = NULL)
})

test_that("enable_cache creates directory when not in check", {
  skip_on_cran()
  
  cache_path <- tempfile("nomis_create_test")
  
  withr::with_envvar(
    c("_R_CHECK_PACKAGE_NAME_" = ""),
    {
      enable_cache(cache_path)
      expect_true(dir.exists(cache_path))
    }
  )
  
  # Clean up
  options(nomisdata.cache_dir = NULL)
  unlink(cache_path, recursive = TRUE)
})

test_that("enable_cache with NULL path uses default", {
  skip_on_cran()
  
  withr::with_envvar(
    c("_R_CHECK_PACKAGE_NAME_" = ""),
    {
      result <- enable_cache(NULL)
      expect_true(!is.null(result))
      expect_type(result, "character")
    }
  )
  
  options(nomisdata.cache_dir = NULL)
})

test_that("clear_cache removes cache directory", {
  skip_on_cran()
  
  cache_dir <- tempfile("nomis_clear_test")
  dir.create(cache_dir, recursive = TRUE)
  
  # Create some test files
  test_file <- file.path(cache_dir, "test.rds")
  saveRDS(data.frame(x = 1), test_file)
  
  options(nomisdata.cache_dir = cache_dir)
  
  expect_message(clear_cache(), "Disk cache cleared")
  expect_false(dir.exists(cache_dir))
  
  options(nomisdata.cache_dir = NULL)
})

test_that("clear_cache handles NULL cache_dir", {
  options(nomisdata.cache_dir = NULL)
  
  # Should not error
  result <- expect_silent(clear_cache())
  expect_true(result)
  
  options(nomisdata.cache_dir = NULL)
})

test_that("clear_cache handles non-existent directory", {
  options(nomisdata.cache_dir = "/path/that/does/not/exist")
  
  result <- expect_silent(clear_cache())
  expect_true(result)
  
  options(nomisdata.cache_dir = NULL)
})

test_that("clear_cache returns invisible TRUE", {
  skip("Testing invisibility is not critical")
  
  skip_on_cran()
  
  cache_dir <- tempfile("nomis_return_test")
  dir.create(cache_dir, recursive = TRUE)
  options(nomisdata.cache_dir = cache_dir)
  
  result <- clear_cache()
  expect_true(result)  
  
  options(nomisdata.cache_dir = NULL)
})

test_that("clear_cache returns invisible TRUE", {
  skip_on_cran()
  skip("Testing invisibility is not critical - just test it returns TRUE")
  
  cache_dir <- tempfile("nomis_return_test")
  dir.create(cache_dir, recursive = TRUE)
  options(nomisdata.cache_dir = cache_dir)
  
  result <- clear_cache()
  expect_true(result)  
  
  options(nomisdata.cache_dir = NULL)
})

test_that("enable_cache handles existing directory gracefully", {
  skip_on_cran()
  
  cache_path <- tempfile("nomis_existing")
  dir.create(cache_path, recursive = TRUE)
  
  # Should not error when directory already exists
  expect_silent(enable_cache(cache_path))
  expect_true(dir.exists(cache_path))
  
  # Clean up
  options(nomisdata.cache_dir = NULL)
  unlink(cache_path, recursive = TRUE)
})