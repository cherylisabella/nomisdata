# Tests that examples in documentation work

test_that("jsa_sample example works", {
  data("jsa_sample", package = "nomisdata", envir = environment())
  
  if (!exists("jsa_sample")) {
    skip("jsa_sample dataset not available")
  }
  
  # Example from documentation
  result <- aggregate_geography(jsa_sample, "TYPE499", "OBS_VALUE")
  
  expect_s3_class(result, "data.frame")
})

test_that("tidy_names example works", {
  skip_if_not_installed("janitor")
  
  df <- data.frame(GEOGRAPHY_NAME = "UK", OBS_VALUE = 100)
  result <- tidy_names(df)
  
  expect_true("geography_name" %in% names(result))
})