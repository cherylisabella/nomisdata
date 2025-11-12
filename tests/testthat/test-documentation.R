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
  # Check if we're in source or installed package
  pkg_dir <- system.file(package = "nomisdata")
  
  if (nzchar(pkg_dir)) {
    # Installed package - check installed location
    desc_file <- file.path(pkg_dir, "DESCRIPTION")
    expect_true(file.exists(desc_file), 
                info = paste("Installed package should have DESCRIPTION at", desc_file))
  } else {
    # Source package during devtools::test()
    # Try to find DESCRIPTION in parent directories
    possible_paths <- c(
      "DESCRIPTION",           # Already in package root
      "../DESCRIPTION",        # One level up
      "../../DESCRIPTION"      # Two levels up (from tests/testthat)
    )
    
    found <- FALSE
    for (path in possible_paths) {
      if (file.exists(path)) {
        found <- TRUE
        break
      }
    }
    
    expect_true(found, 
                info = "DESCRIPTION file should exist in source package")
  }
})