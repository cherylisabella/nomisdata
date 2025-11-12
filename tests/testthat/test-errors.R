# Tests for error handling across the package

test_that("package handles network errors gracefully", {
  skip_on_cran()
  
  # Test with invalid URL
  expect_error({
    req <- httr2::request("https://invalid.nomisweb.co.uk") |>
      httr2::req_timeout(1)
    execute_request(req)
  })
})

test_that("package handles malformed API responses", {
  # Mock a response with minimal but valid CSV
  mock_csv <- "col1,col2\nval1,val2"
  
  mock_resp <- structure(
    list(body = charToRaw(mock_csv)),
    class = "httr2_response"
  )
  
  local_mocked_bindings(
    resp_has_body = function(x) TRUE,
    resp_body_string = function(x) mock_csv,
    .package = "httr2"
  )
  
  # Should parse without error
  result <- parse_csv_response(mock_resp)
  expect_s3_class(result, "tbl_df")
})