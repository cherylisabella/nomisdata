# Tests for package constants

test_that("API URLs are correctly defined", {
  expect_match(NOMIS_BASE, "https://www.nomisweb.co.uk/api")
  expect_match(NOMIS_DATASET, "dataset")
  expect_match(NOMIS_CONTENT, "contenttype")
  expect_match(NOMIS_CODELIST, "codelist")
})

test_that("rate limits are defined", {
  expect_type(GUEST_LIMIT, "integer")
  expect_type(API_LIMIT, "integer")
  expect_true(API_LIMIT > GUEST_LIMIT)
  expect_equal(GUEST_LIMIT, 25000L)
  expect_equal(API_LIMIT, 100000L)
})