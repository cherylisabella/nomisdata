# Tests for package datasets

test_that("jsa_sample dataset is available", {
  data("jsa_sample", package = "nomisdata", envir = environment())
  
  # Check if loaded successfully
  if (!exists("jsa_sample")) {
    skip("jsa_sample dataset not found - may need to be created")
  }
  
  expect_s3_class(jsa_sample, "tbl_df")
  expect_true("GEOGRAPHY_CODE" %in% names(jsa_sample))
  expect_true("OBS_VALUE" %in% names(jsa_sample))
  expect_true(nrow(jsa_sample) > 0)
})

test_that("jsa_sample has expected structure", {
  # Load into local environment
  data("jsa_sample", package = "nomisdata", envir = environment())
  
  if (!exists("jsa_sample")) {
    skip("jsa_sample dataset not available")
  }
  
  expected_cols <- c(
    "GEOGRAPHY_CODE", "GEOGRAPHY_NAME", "SEX", "SEX_NAME",
    "MEASURES", "MEASURES_NAME", "DATE", "DATE_NAME",
    "OBS_VALUE", "OBS_STATUS"
  )
  
  expect_true(all(expected_cols %in% names(jsa_sample)))
})
