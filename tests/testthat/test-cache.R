# get_nomis_cache_dir tests
test_that("get_nomis_cache_dir uses tempdir during R CMD check", {
  withr::with_envvar(c("_R_CHECK_PACKAGE_NAME_" = "nomisdata"), {
    path <- get_nomis_cache_dir()
    expect_match(path, tempdir(), fixed = TRUE)
    expect_match(path, "nomisdata")
  })
})

test_that("get_nomis_cache_dir respects NOT_CRAN=false", {
  withr::with_envvar(c("NOT_CRAN" = "false"), {
    path <- get_nomis_cache_dir()
    expect_match(path, tempdir(), fixed = TRUE)
  })
})

test_that("get_nomis_cache_dir uses NOMISDATA_CACHE_DIR env var", {
  withr::with_envvar(
    c("NOMISDATA_CACHE_DIR" = "/custom/path", "_R_CHECK_PACKAGE_NAME_" = ""),
    {
      path <- get_nomis_cache_dir()
      expect_equal(path, "/custom/path")
    }
  )
})

test_that("get_nomis_cache_dir uses R_user_dir on R >= 4.0", {
  skip_if(getRversion() < "4.0.0")
  withr::with_envvar(
    c("NOMISDATA_CACHE_DIR" = "", "_R_CHECK_PACKAGE_NAME_" = ""),
    {
      path <- get_nomis_cache_dir()
      expect_type(path, "character")
      expect_true(nchar(path) > 0)
    }
  )
})

test_that("get_nomis_cache_dir falls back to tempdir", {
  withr::with_envvar(
    c("NOMISDATA_CACHE_DIR" = "", "_R_CHECK_PACKAGE_NAME_" = ""),
    {
      path <- get_nomis_cache_dir()
      expect_type(path, "character")
      expect_true(nchar(path) > 0)
    }
  )
})

# enable_cache tests
test_that("enable_cache sets option", {
  withr::local_options(nomisdata.cache_dir = NULL)
  withr::with_envvar(c("_R_CHECK_PACKAGE_NAME_" = ""), {
    temp <- tempfile()
    result <- enable_cache(temp)
    expect_equal(getOption("nomisdata.cache_dir"), temp)
  })
})

test_that("enable_cache uses tempdir during check", {
  withr::local_options(nomisdata.cache_dir = NULL)
  withr::with_envvar(c("_R_CHECK_PACKAGE_NAME_" = "nomisdata"), {
    result <- enable_cache("/some/path")
    expect_match(result, tempdir(), fixed = TRUE)
  })
})

test_that("enable_cache handles NULL path", {
  withr::local_options(nomisdata.cache_dir = NULL)
  withr::with_envvar(c("_R_CHECK_PACKAGE_NAME_" = ""), {
    result <- enable_cache(NULL)
    expect_type(result, "character")
  })
})

test_that("enable_cache creates dir when not in check", {
  withr::local_options(nomisdata.cache_dir = NULL)
  withr::with_envvar(c("_R_CHECK_PACKAGE_NAME_" = ""), {
    temp <- tempfile()
    enable_cache(temp)
    expect_true(dir.exists(temp))
    unlink(temp, recursive = TRUE)
  })
})

test_that("enable_cache skips creation during check", {
  withr::local_options(nomisdata.cache_dir = NULL)
  withr::with_envvar(c("_R_CHECK_PACKAGE_NAME_" = "nomisdata"), {
    temp <- tempfile()
    enable_cache(temp)
    expect_false(dir.exists(temp))
  })
})

# clear_cache tests
test_that("clear_cache removes directory", {
  withr::local_options(nomisdata.cache_dir = NULL)
  temp <- tempfile()
  dir.create(temp)
  options(nomisdata.cache_dir = temp)
  
  clear_cache()
  expect_false(dir.exists(temp))
})

test_that("clear_cache handles NULL cache_dir", {
  withr::local_options(nomisdata.cache_dir = NULL)
  expect_silent(clear_cache())
})

test_that("clear_cache handles nonexistent directory", {
  withr::local_options(nomisdata.cache_dir = "/fake/path")
  expect_silent(clear_cache())
})

test_that("clear_cache returns invisible TRUE", {
  withr::local_options(nomisdata.cache_dir = NULL)
  result <- clear_cache()
  expect_true(result)
})

test_that("clear_cache messages when clearing", {
  temp <- tempfile()
  dir.create(temp)
  withr::local_options(nomisdata.cache_dir = temp)
  
  expect_message(clear_cache(), "cleared")
})

# Integration with cache-enhanced.R functions
test_that("get_cache_key creates deterministic hash", {
  key1 <- get_cache_key("NM_1_1", list(time = "latest"))
  key2 <- get_cache_key("NM_1_1", list(time = "latest"))
  expect_identical(key1, key2)
  expect_equal(nchar(key1), 32)
})

test_that("cache_data and get_cached_data work together", {
  temp <- tempfile()
  dir.create(temp)
  withr::local_options(nomisdata.cache_dir = temp)
  on.exit(unlink(temp, recursive = TRUE))
  
  test_data <- data.frame(x = 1:3)
  cache_data("test", test_data)
  
  retrieved <- get_cached_data("test")
  expect_equal(retrieved, test_data)
})

test_that("get_cached_data respects max_age_days", {
  temp <- tempfile()
  dir.create(temp)
  withr::local_options(nomisdata.cache_dir = temp)
  on.exit(unlink(temp, recursive = TRUE))
  
  test_data <- data.frame(x = 1)
  cache_data("old", test_data)
  
  meta_file <- file.path(temp, "old_meta.rds")
  meta <- readRDS(meta_file)
  meta$timestamp <- Sys.time() - as.difftime(31, units = "days")
  saveRDS(meta, meta_file)
  
  result <- suppressMessages(get_cached_data("old", max_age_days = 30))
  expect_null(result)
})