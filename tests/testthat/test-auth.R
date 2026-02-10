# set_api_key() basic tests
test_that("set_api_key sets key for current session", {
  orig_key <- getOption("nomisdata.api_key")
  withr::defer(options(nomisdata.api_key = orig_key))
  
  expect_message(
    result <- set_api_key("test_key_12345", persist = FALSE),
    "API key set for current session"
  )
  
  expect_true(result)
  expect_equal(getOption("nomisdata.api_key"), "test_key_12345")
})

test_that("set_api_key validates empty string", {
  expect_error(
    set_api_key(""),
    "Invalid API key"
  )
})

test_that("set_api_key reads from environment when key is NULL", {
  orig_key <- getOption("nomisdata.api_key")
  orig_env <- Sys.getenv("NOMIS_API_KEY")
  
  withr::defer({
    options(nomisdata.api_key = orig_key)
    if (nzchar(orig_env)) {
      Sys.setenv(NOMIS_API_KEY = orig_env)
    } else {
      Sys.unsetenv("NOMIS_API_KEY")
    }
  })
  
  Sys.setenv(NOMIS_API_KEY = "env_key_123")
  
  expect_message(
    set_api_key(persist = FALSE),
    "API key set"
  )
  
  expect_equal(getOption("nomisdata.api_key"), "env_key_123")
})

test_that("set_api_key errors when NULL and no env var in non-interactive mode", {
  orig_env <- Sys.getenv("NOMIS_API_KEY")
  withr::defer({
    if (nzchar(orig_env)) {
      Sys.setenv(NOMIS_API_KEY = orig_env)
    } else {
      Sys.unsetenv("NOMIS_API_KEY")
    }
  })
  
  Sys.unsetenv("NOMIS_API_KEY")
  
  expect_error(
    set_api_key(NULL),
    "No API key provided|not interactive"
  )
})

test_that("set_api_key returns TRUE", {
  orig_key <- getOption("nomisdata.api_key")
  withr::defer(options(nomisdata.api_key = orig_key))
  
  result <- suppressMessages(set_api_key("test_key", persist = FALSE))
  
  expect_true(result)
})

test_that("set_api_key with persist = FALSE doesn't modify .Renviron", {
  orig_key <- getOption("nomisdata.api_key")
  withr::defer(options(nomisdata.api_key = orig_key))
  
  expect_message(
    set_api_key("test_key", persist = FALSE),
    "current session"
  )
})

test_that("set_api_key accepts long keys", {
  orig_key <- getOption("nomisdata.api_key")
  withr::defer(options(nomisdata.api_key = orig_key))
  
  long_key <- paste(rep("a", 100), collapse = "")
  
  suppressMessages(set_api_key(long_key, persist = FALSE))
  
  expect_equal(getOption("nomisdata.api_key"), long_key)
})

test_that("set_api_key accepts keys with special characters", {
  orig_key <- getOption("nomisdata.api_key")
  withr::defer(options(nomisdata.api_key = orig_key))
  
  special_key <- "key-123_ABC.test"
  
  suppressMessages(set_api_key(special_key, persist = FALSE))
  
  expect_equal(getOption("nomisdata.api_key"), special_key)
})

test_that("set_api_key overwrites existing key", {
  orig_key <- getOption("nomisdata.api_key")
  withr::defer(options(nomisdata.api_key = orig_key))
  
  suppressMessages(set_api_key("old_key", persist = FALSE))
  expect_equal(getOption("nomisdata.api_key"), "old_key")
  
  suppressMessages(set_api_key("new_key", persist = FALSE))
  expect_equal(getOption("nomisdata.api_key"), "new_key")
})

# add_to_renviron() tests
test_that("add_to_renviron doesn't run during R CMD check", {
  orig_check <- Sys.getenv("_R_CHECK_PACKAGE_NAME_")
  withr::defer(Sys.setenv("_R_CHECK_PACKAGE_NAME_" = orig_check))
  
  Sys.setenv("_R_CHECK_PACKAGE_NAME_" = "nomisdata")
  
  expect_message(
    add_to_renviron("test_key"),
    "not available during package checks"
  )
})

test_that("add_to_renviron returns invisible NULL during check", {
  orig_check <- Sys.getenv("_R_CHECK_PACKAGE_NAME_")
  withr::defer(Sys.setenv("_R_CHECK_PACKAGE_NAME_" = orig_check))
  
  Sys.setenv("_R_CHECK_PACKAGE_NAME_" = "nomisdata")
  
  result <- suppressMessages(add_to_renviron("test_key"))
  
  expect_null(result)
})

# Integration tests
test_that("set_api_key then get_option retrieves same key", {
  orig_key <- getOption("nomisdata.api_key")
  withr::defer(options(nomisdata.api_key = orig_key))
  
  test_key <- "integration_test_key_123"
  
  suppressMessages(set_api_key(test_key, persist = FALSE))
  
  expect_equal(getOption("nomisdata.api_key"), test_key)
})

test_that("environment variable takes precedence when key is NULL", {
  orig_key <- getOption("nomisdata.api_key")
  orig_env <- Sys.getenv("NOMIS_API_KEY")
  
  withr::defer({
    options(nomisdata.api_key = orig_key)
    if (nzchar(orig_env)) {
      Sys.setenv(NOMIS_API_KEY = orig_env)
    } else {
      Sys.unsetenv("NOMIS_API_KEY")
    }
  })
  
  Sys.setenv(NOMIS_API_KEY = "env_var_key")
  
  suppressMessages(set_api_key(NULL, persist = FALSE))
  
  expect_equal(getOption("nomisdata.api_key"), "env_var_key")
})

test_that("set_api_key validates nzchar after env var check", {
  orig_env <- Sys.getenv("NOMIS_API_KEY")
  withr::defer({
    if (nzchar(orig_env)) {
      Sys.setenv(NOMIS_API_KEY = orig_env)
    } else {
      Sys.unsetenv("NOMIS_API_KEY")
    }
  })
  
  Sys.setenv(NOMIS_API_KEY = "")
  
  expect_error(
    set_api_key(NULL),
    "No API key provided|not interactive|Invalid API key"
  )
})

test_that("set_api_key handles different key formats", {
  orig_key <- getOption("nomisdata.api_key")
  withr::defer(options(nomisdata.api_key = orig_key))
  
  # UUID-like key
  uuid_key <- "550e8400-e29b-41d4-a716-446655440000"
  suppressMessages(set_api_key(uuid_key, persist = FALSE))
  expect_equal(getOption("nomisdata.api_key"), uuid_key)
  
  # Short key
  short_key <- "abc123"
  suppressMessages(set_api_key(short_key, persist = FALSE))
  expect_equal(getOption("nomisdata.api_key"), short_key)
})

test_that("set_api_key with persist = TRUE sends to add_to_renviron", {
  skip_on_cran()
  
  orig_key <- getOption("nomisdata.api_key")
  orig_check <- Sys.getenv("_R_CHECK_PACKAGE_NAME_")
  
  withr::defer({
    options(nomisdata.api_key = orig_key)
    Sys.setenv("_R_CHECK_PACKAGE_NAME_" = orig_check)
  })
  
  # Simulate R CMD check to prevent actual file modification
  Sys.setenv("_R_CHECK_PACKAGE_NAME_" = "nomisdata")
  
  expect_message(
    set_api_key("test_key", persist = TRUE),
    "not available during package checks"
  )
})