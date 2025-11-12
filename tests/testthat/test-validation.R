# Input validation tests

test_that("fetch_nomis validates time and date parameters", {
  skip_if_no_api()
  skip_on_cran()
  
  # Both time and date should work, but not tested together here
  expect_error(
    fetch_nomis("NM_1_1", time = "latest", geography = "TYPE499"),
    NA
  )
  
  expect_error(
    fetch_nomis("NM_1_1", date = "latest", geography = "TYPE499"),
    NA
  )
})

test_that("aggregate functions validate column names", {
  df <- data.frame(x = 1:5, y = letters[1:5])
  
  expect_error(
    aggregate_geography(df, "TYPE499", "MISSING_COL"),
    "not found"
  )
  
  expect_error(
    aggregate_time(df, "year", "VALUE"),
    "DATE.*column"
  )
})

test_that("functions handle NULL inputs gracefully", {
  expect_error(
    get_codes(NULL),
    "required"
  )
  
  expect_error(
    describe_dataset(NULL),
    NA  # NULL is valid for describe_dataset
  )
})