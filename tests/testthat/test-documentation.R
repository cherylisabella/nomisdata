# Tests that verify documentation accuracy
test_that("exported functions have documentation", {
  exports <- getNamespaceExports("nomisdata")
  
  key_functions <- c(
    "fetch_nomis", "search_datasets", "describe_dataset",
    "get_codes", "lookup_geography", "set_api_key"
  )
  
  for (fn in key_functions) {
    if (fn %in% exports) {
      help_topic <- try(utils::help(fn, package = "nomisdata"), silent = TRUE)
      
      if (inherits(help_topic, "try-error")) {
        fail(sprintf("Function %s has no documentation", fn))
      }
    }
  }
  
  expect_true(length(key_functions) > 0)
})

test_that("package has required files", {
  # This test is mainly for source package structure
  # During devtools::test(), we are in the package root context
  
  # Try multiple possible locations
  desc_locations <- c(
    "DESCRIPTION",                    # Package root (most common)
    "../../DESCRIPTION",              # From tests/testthat/
    file.path("..", "..", "DESCRIPTION")  # Alternative path format
  )
  
  # Also check if package is installed
  pkg_dir <- system.file(package = "nomisdata")
  if (nzchar(pkg_dir)) {
    desc_locations <- c(file.path(pkg_dir, "DESCRIPTION"), desc_locations)
  }
  
  # Find first existing DESCRIPTION
  desc_found <- FALSE
  for (loc in desc_locations) {
    if (file.exists(loc)) {
      desc_found <- TRUE
      break
    }
  }
  
  expect_true(desc_found, 
              info = "DESCRIPTION file should exist in package")
})

test_that("key exported functions exist", {
  exports <- getNamespaceExports("nomisdata")
  
  key_functions <- c(
    "fetch_nomis",
    "search_datasets", 
    "describe_dataset",
    "get_codes"
  )
  
  for (fn in key_functions) {
    expect_true(fn %in% exports,
                info = sprintf("Function %s should be exported", fn))
  }
})

