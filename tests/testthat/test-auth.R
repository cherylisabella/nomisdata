test_that("set_api_key sets key for current session", {
  # Save original key
  orig_key <- getOption("nomisdata.api_key")
  on.exit(options(nomisdata.api_key = orig_key))
  
  # Set new key
  result <- set_api_key("test_key_12345", persist = FALSE)
  
  expect_true(result)
  expect_equal(getOption("nomisdata.api_key"), "test_key_12345")
})

test_that("set_api_key validates input", {
  expect_error(
    set_api_key(""),
    "Invalid API key"
  )
  
  # NULL with interactive=FALSE should error
  # The function checks Sys.getenv first, then falls back
  orig_env <- Sys.getenv("NOMIS_API_KEY")
  Sys.setenv(NOMIS_API_KEY = "")
  on.exit(Sys.setenv(NOMIS_API_KEY = orig_env))
  
  expect_error(
    set_api_key(NULL),
    "No API key provided|Invalid API key"
  )
})

test_that("set_api_key reads from environment", {
  orig_key <- getOption("nomisdata.api_key")
  orig_env <- Sys.getenv("NOMIS_API_KEY")
  on.exit({
    options(nomisdata.api_key = orig_key)
    Sys.setenv(NOMIS_API_KEY = orig_env)
  })
  
  Sys.setenv(NOMIS_API_KEY = "env_key_123")
  result <- set_api_key(persist = FALSE)
  
  expect_equal(getOption("nomisdata.api_key"), "env_key_123")
})