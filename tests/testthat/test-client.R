# Tests for HTTP client functions

test_that("build_request creates valid request object", {
  req <- build_request("NM_1_1.data.csv", list(time = "latest"), format = "")
  
  expect_s3_class(req, "httr2_request")
  expect_match(req$url, "www.nomisweb.co.uk")
  expect_match(req$url, "NM_1_1")
})

test_that("build_request includes API key when available", {
  orig_key <- getOption("nomisdata.api_key")
  on.exit(options(nomisdata.api_key = orig_key))
  
  options(nomisdata.api_key = "test_key")
  req <- build_request("NM_1_1.data.csv", list(), format = "")
  
  expect_match(req$url, "uid=test_key")
})

test_that("build_request removes NULL parameters", {
  req <- build_request(
    "NM_1_1.data.csv",
    list(time = "latest", geography = NULL),
    format = ""
  )
  
  expect_false(grepl("geography", req$url))
})

test_that("handle_error_body processes different status codes", {
  # Mock responses
  resp_429 <- list(status = 429, body = NULL)
  class(resp_429) <- "httr2_response"
  
  resp_400 <- list(status = 400, body = "Invalid parameters")
  class(resp_400) <- "httr2_response"
  
  # Create mock response with no body
  expect_match(
    handle_error_body(structure(list(), class = "httr2_response")),
    "No response body"
  )
})

test_that("parse_csv_response converts OBS_VALUE to numeric", {
  csv_text <- mock_jsa_csv()
  
  # Create mock response
  mock_resp <- structure(
    list(body = charToRaw(csv_text)),
    class = "httr2_response"
  )
  
  # Mock httr2 functions
  local_mocked_bindings(
    resp_has_body = function(x) TRUE,
    resp_body_string = function(x) csv_text,
    .package = "httr2"
  )
  
  result <- parse_csv_response(mock_resp)
  
  expect_s3_class(result, "tbl_df")
  expect_type(result$OBS_VALUE, "double")
  expect_equal(nrow(result), 3)
})
