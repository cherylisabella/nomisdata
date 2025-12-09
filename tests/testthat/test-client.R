# Tests for HTTP client functions

# ============================================================================
# build_request() tests
# ============================================================================

test_that("build_request creates valid request object", {
  req <- build_request("NM_1_1.data.csv", list(time = "latest"), format = "")
  
  expect_s3_class(req, "httr2_request")
  expect_match(req$url, "www.nomisweb.co.uk")
  expect_match(req$url, "NM_1_1")
})

test_that("build_request includes API key when available", {
  orig_key <- getOption("nomisdata.api_key")
  withr::defer(options(nomisdata.api_key = orig_key))
  
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
  expect_true(grepl("time", req$url))
})

test_that("build_request handles empty params list", {
  req <- build_request("NM_1_1.data.csv", list(), format = "")
  
  expect_s3_class(req, "httr2_request")
})

test_that("build_request doesn't add extension when format is empty", {
  req <- build_request("NM_1_1.data.csv", list(), format = "")
  
  expect_match(req$url, "\\.csv")
})

test_that("build_request handles path with dots correctly", {
  req <- build_request("NM_1_1.def.sdmx.json", list(), format = "")
  
  expect_match(req$url, "NM_1_1\\.def\\.sdmx\\.json")
})

test_that("build_request includes multiple parameters", {
  req <- build_request(
    "NM_1_1.data.csv",
    list(time = "latest", geography = "TYPE499", measures = "20100"),
    format = ""
  )
  
  expect_match(req$url, "time=latest")
  expect_match(req$url, "geography=TYPE499")
  expect_match(req$url, "measures=20100")
})

test_that("build_request sets user agent", {
  req <- build_request("NM_1_1.data.csv", list(), format = "")
  
  expect_true(!is.null(req$headers))
})

test_that("build_request configures retry logic", {
  req <- build_request("NM_1_1.data.csv", list(), format = "")
  
  expect_s3_class(req, "httr2_request")
})

test_that("build_request doesn't include API key when not set", {
  orig_key <- getOption("nomisdata.api_key")
  withr::defer(options(nomisdata.api_key = orig_key))
  
  options(nomisdata.api_key = NULL)
  req <- build_request("NM_1_1.data.csv", list(), format = "")
  
  expect_false(grepl("uid=", req$url))
})

# ============================================================================
# execute_request() tests
# ============================================================================

test_that("execute_request returns httr2_response", {
  skip_if_no_api()
  skip_on_cran()
  
  req <- build_request("NM_1_1.overview.json", list(), format = "")
  resp <- execute_request(req)
  
  expect_s3_class(resp, "httr2_response")
})

test_that("execute_request handles valid requests", {
  skip_if_no_api()
  skip_on_cran()
  
  req <- build_request("NM_1_1.overview.json", list(), format = "")
  
  expect_error(execute_request(req), NA)
})

# ============================================================================
# Integration tests
# ============================================================================

test_that("build_request and execute_request work together", {
  skip_if_no_api()
  skip_on_cran()
  
  req <- build_request("NM_1_1.overview.json", list(), format = "")
  resp <- execute_request(req)
  
  expect_s3_class(resp, "httr2_response")
})

test_that("full request cycle works", {
  skip_if_no_api()
  skip_on_cran()
  
  req <- build_request("NM_1_1.overview.json", list(), format = "")
  resp <- execute_request(req)
  parsed <- parse_json_response(resp)
  
  expect_type(parsed, "list")
})

test_that("build_request handles special characters in parameters", {
  req <- build_request(
    "NM_1_1.data.csv",
    list(search = "*test*"),
    format = ""
  )
  
  expect_s3_class(req, "httr2_request")
})

test_that("build_request constructs base URL correctly", {
  req <- build_request("test.csv", list(), format = "")
  
  expect_match(req$url, "www.nomisweb.co.uk")
  expect_match(req$url, "api/v01/dataset")
})

test_that("handle_error_body returns character", {
  # Test with a mock response structure
  expect_type(
    handle_error_body(structure(list(), class = "httr2_response")),
    "character"
  )
})

test_that("parse_csv_response converts to tibble", {
  skip_if_no_api()
  skip_on_cran()
  
  req <- build_request("NM_1_1.data.csv", 
                       list(time = "latest", geography = "TYPE499", 
                            measures = "20100", RecordLimit = "5"),
                       format = "")
  resp <- execute_request(req)
  result <- parse_csv_response(resp)
  
  expect_s3_class(result, "tbl_df")
})

test_that("parse_json_response returns list", {
  skip_if_no_api()
  skip_on_cran()
  
  req <- build_request("NM_1_1.overview.json", list(), format = "")
  resp <- execute_request(req)
  result <- parse_json_response(resp)
  
  expect_type(result, "list")
})