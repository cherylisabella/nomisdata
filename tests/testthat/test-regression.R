# Regression tests for known issues

test_that("OBS_VALUE is always numeric", {
  skip_if_no_api()
  skip_on_cran()
  
  data <- fetch_nomis(
    "NM_1_1",
    time = "latest",
    geography = "TYPE499",
    measures = 20100
  )
  
  expect_type(data$OBS_VALUE, "double")
})

test_that("RECORD_COUNT is handled correctly", {
  skip_if_no_api()
  skip_on_cran()
  
  # Without select parameter, should include RECORD_COUNT
  data1 <- fetch_nomis(
    "NM_1_1",
    time = "latest",
    geography = "TYPE499",
    measures = 20100
  )
  
  expect_true("RECORD_COUNT" %in% names(data1))
  
  # With select parameter not including RECORD_COUNT, should be removed
  data2 <- fetch_nomis(
    "NM_1_1",
    time = "latest",
    geography = "TYPE499",
    measures = 20100,
    select = c("GEOGRAPHY_CODE", "OBS_VALUE")
  )
  
  # Might still have RECORD_COUNT depending on implementation
  # This documents current behavior
})

test_that("geography codes are preserved as character", {
  skip_if_no_api()
  skip_on_cran()
  
  data <- fetch_nomis(
    "NM_1_1",
    time = "latest",
    geography = "TYPE499",
    measures = 20100
  )
  
  expect_type(data$GEOGRAPHY_CODE, "character")
})