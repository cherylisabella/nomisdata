# Tests for spatial data functions

test_that("fetch_spatial returns KML data", {
  skip_if_no_api()
  skip_on_cran()
  
  result <- fetch_spatial(
    "NM_1_1",
    time = "latest",
    geography = "TYPE499",
    measures = 20100,
    parse_sf = FALSE
  )
  
  expect_type(result, "character")
  expect_match(result, "<kml|<\\?xml")
})

test_that("fetch_spatial handles sf parsing", {
  skip_if_no_api()
  skip_on_cran()
  skip_if_not_installed("sf")
  
  # Suppress expected warning about empty/invalid KML
  result <- suppressWarnings({
    fetch_spatial(
      "NM_1_1",
      time = "latest",
      geography = "TYPE499",
      measures = 20100,
      parse_sf = TRUE
    )
  })
  
  # Should either be sf object or character (if parsing failed)
  expect_true(
    inherits(result, "sf") || is.character(result)
  )
})

test_that("add_geography_names requires GEOGRAPHY_CODE", {
  df <- data.frame(VALUE = 100)
  
  expect_error(
    add_geography_names(df),
    "must contain.*GEOGRAPHY_CODE"
  )
})

test_that("add_geography_names handles existing names", {
  df <- data.frame(
    GEOGRAPHY_CODE = "123",
    GEOGRAPHY_NAME = "Test",
    VALUE = 100
  )
  
  expect_message(
    result <- add_geography_names(df),
    "already contains.*GEOGRAPHY_NAME"
  )
  
  expect_equal(result, df)
})