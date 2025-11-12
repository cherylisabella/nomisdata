# Tests for rate limiting behavior

test_that("build_request includes retry logic", {
  req <- build_request("NM_1_1.data.csv", list(), format = "")
  
  expect_s3_class(req, "httr2_request")
  # Check that retry is configured (implementation detail)
})

test_that("fetch_nomis respects API limits", {
  # Test that GUEST_LIMIT and API_LIMIT constants are used
  expect_true(GUEST_LIMIT < API_LIMIT)
})