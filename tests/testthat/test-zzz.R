# Tests for package load hooks

test_that(".onLoad sets API key from environment", {
  old_key <- Sys.getenv("NOMIS_API_KEY")
  old_option <- getOption("nomisdata.api_key")
  
  withr::defer({
    if (nzchar(old_key)) {
      Sys.setenv(NOMIS_API_KEY = old_key)
    } else {
      Sys.unsetenv("NOMIS_API_KEY")
    }
    options(nomisdata.api_key = old_option)
  })
  
  Sys.setenv(NOMIS_API_KEY = "test-key-123")
  options(nomisdata.api_key = NULL)
  
  .onLoad(NULL, NULL)
  
  expect_equal(getOption("nomisdata.api_key"), "test-key-123")
})

test_that(".onLoad handles empty API key", {
  old_key <- Sys.getenv("NOMIS_API_KEY")
  old_option <- getOption("nomisdata.api_key")
  
  withr::defer({
    if (nzchar(old_key)) {
      Sys.setenv(NOMIS_API_KEY = old_key)
    } else {
      Sys.unsetenv("NOMIS_API_KEY")
    }
    options(nomisdata.api_key = old_option)
  })
  
  Sys.unsetenv("NOMIS_API_KEY")
  options(nomisdata.api_key = NULL)
  
  .onLoad(NULL, NULL)
  
  expect_null(getOption("nomisdata.api_key"))
})

test_that(".onLoad returns invisibly", {
  old_key <- Sys.getenv("NOMIS_API_KEY")
  withr::defer({
    if (nzchar(old_key)) {
      Sys.setenv(NOMIS_API_KEY = old_key)
    } else {
      Sys.unsetenv("NOMIS_API_KEY")
    }
  })
  
  result <- .onLoad(NULL, NULL)
  expect_null(result)
})

test_that(".onAttach shows message when no API key", {
  old_option <- getOption("nomisdata.api_key")
  withr::defer(options(nomisdata.api_key = old_option))
  
  options(nomisdata.api_key = NULL)
  
  expect_message(
    .onAttach(NULL, NULL),
    "No API key found"
  )
})

test_that(".onAttach message mentions guest user limits", {
  old_option <- getOption("nomisdata.api_key")
  withr::defer(options(nomisdata.api_key = old_option))
  
  options(nomisdata.api_key = NULL)
  
  expect_message(
    .onAttach(NULL, NULL),
    "25,000 rows"
  )
})

test_that(".onAttach message includes registration URL", {
  old_option <- getOption("nomisdata.api_key")
  withr::defer(options(nomisdata.api_key = old_option))
  
  options(nomisdata.api_key = NULL)
  
  expect_message(
    .onAttach(NULL, NULL),
    "nomisweb.co.uk"
  )
})

test_that(".onAttach message mentions set_api_key function", {
  old_option <- getOption("nomisdata.api_key")
  withr::defer(options(nomisdata.api_key = old_option))
  
  options(nomisdata.api_key = NULL)
  
  expect_message(
    .onAttach(NULL, NULL),
    "set_api_key"
  )
})

test_that(".onAttach silent when API key exists", {
  old_option <- getOption("nomisdata.api_key")
  withr::defer(options(nomisdata.api_key = old_option))
  
  options(nomisdata.api_key = "test-key")
  
  expect_silent(.onAttach(NULL, NULL))
})

test_that(".onLoad doesn't error with NULL libname", {
  expect_error(.onLoad(NULL, "nomisdata"), NA)
})

test_that(".onLoad doesn't error with NULL pkgname", {
  expect_error(.onLoad("path", NULL), NA)
})

test_that(".onAttach doesn't error with NULL libname", {
  old_option <- getOption("nomisdata.api_key")
  withr::defer(options(nomisdata.api_key = old_option))
  
  options(nomisdata.api_key = "test")
  
  expect_error(.onAttach(NULL, "nomisdata"), NA)
})

test_that(".onAttach doesn't error with NULL pkgname", {
  old_option <- getOption("nomisdata.api_key")
  withr::defer(options(nomisdata.api_key = old_option))
  
  options(nomisdata.api_key = "test")
  
  expect_error(.onAttach("path", NULL), NA)
})

test_that(".onLoad overwrites option when env var is set", {
  old_option <- getOption("nomisdata.api_key")
  old_key <- Sys.getenv("NOMIS_API_KEY")
  
  withr::defer({
    options(nomisdata.api_key = old_option)
    if (nzchar(old_key)) {
      Sys.setenv(NOMIS_API_KEY = old_key)
    } else {
      Sys.unsetenv("NOMIS_API_KEY")
    }
  })
  
  options(nomisdata.api_key = "old-key")
  Sys.setenv(NOMIS_API_KEY = "new-key")
  
  .onLoad(NULL, NULL)
  
  expect_equal(getOption("nomisdata.api_key"), "new-key")
})

test_that(".onAttach uses packageStartupMessage", {
  old_option <- getOption("nomisdata.api_key")
  withr::defer(options(nomisdata.api_key = old_option))
  
  options(nomisdata.api_key = NULL)
  
  expect_message(.onAttach(NULL, NULL))
  
  expect_silent(suppressPackageStartupMessages(.onAttach(NULL, NULL)))
})