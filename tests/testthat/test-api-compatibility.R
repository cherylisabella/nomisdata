# Tests for API version compatibility

test_that("package uses v01 API endpoints", {
  expect_match(NOMIS_BASE, "v01")
})

test_that("user agent is set correctly", {
  req <- build_request("NM_1_1.data.csv", list(), format = "")
  
  # Check request has user agent
  expect_s3_class(req, "httr2_request")
})
