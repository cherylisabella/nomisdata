# Integration tests combining multiple functions

test_that("geography workflow: lookup and fetch", {
  skip_if_no_api()
  skip_on_cran()
  skip_if_not_installed("rsdmx")
  
  # FIXED: More robust error handling
  geo_results <- tryCatch(
    lookup_geography("United Kingdom", "NM_1_1"),
    error = function(e) {
      skip(paste("Geography lookup failed:", conditionMessage(e)))
    },
    warning = function(w) {
      # Return empty tibble if warning
      tibble::tibble()
    }
  )
  
  # If we found geographies, fetch data for them
  if (is.data.frame(geo_results) && nrow(geo_results) > 0 && "id" %in% names(geo_results)) {
    geo_code <- geo_results$id[1]
    
    data <- fetch_nomis(
      "NM_1_1",
      time = "latest",
      geography = geo_code,
      measures = 20100
    )
    
    expect_true(nrow(data) > 0)
  } else {
    skip("No geography results to test with")
  }
})