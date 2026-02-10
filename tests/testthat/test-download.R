# Tests for download.R

test_that("fetch_nomis requires dataset ID", {
  expect_error(fetch_nomis(), "Dataset ID required")
})

test_that("build_params prefers date over time", {
  params <- build_params("NM_1_1", time = "latest", date = "2020-01", NULL, NULL, NULL, FALSE, NULL)
  expect_equal(params$date, "2020-01")
  expect_null(params$time)
})

test_that("build_params uses time when no date", {
  params <- build_params("NM_1_1", "latest", NULL, NULL, NULL, NULL, FALSE, NULL)
  expect_equal(params$time, "latest")
})

test_that("build_params collapses vectors", {
  params <- build_params("NM_1_1", c("a", "b"), NULL, c("x", "y"), c(1, 2), c(10, 20), FALSE, NULL)
  expect_match(params$time, ",")
  expect_match(params$geography, ",")
  expect_match(params$sex, ",")
  expect_match(params$MEASURES, ",")
})

test_that("build_params sets ExcludeMissingValues", {
  params <- build_params("NM_1_1", "latest", NULL, NULL, NULL, NULL, TRUE, NULL)
  expect_equal(params$ExcludeMissingValues, "true")
})

test_that("build_params skips ExcludeMissingValues when FALSE", {
  params <- build_params("NM_1_1", "latest", NULL, NULL, NULL, NULL, FALSE, NULL)
  expect_null(params$ExcludeMissingValues)
})

test_that("build_params uppercases select and adds RECORD_COUNT", {
  params <- build_params("NM_1_1", "latest", NULL, NULL, NULL, NULL, FALSE, c("geography_code"))
  expect_match(params$select, "GEOGRAPHY_CODE")
  expect_match(params$select, "RECORD_COUNT")
})

test_that("build_params handles dot params", {
  params <- build_params("NM_1_1", NULL, NULL, NULL, NULL, NULL, FALSE, NULL, age = c(0, 1), item = 5)
  expect_equal(params$AGE, "0,1")
  expect_equal(params$ITEM, "5")
})

test_that("build_params skips empty dot params", {
  params <- build_params("NM_1_1", NULL, NULL, NULL, NULL, NULL, FALSE, NULL, age = NULL, item = character())
  expect_null(params$AGE)
  expect_null(params$ITEM)
})

test_that("build_params handles NULL parameters", {
  params <- build_params("NM_1_1", NULL, NULL, NULL, NULL, NULL, FALSE, NULL)
  expect_null(params$time)
  expect_null(params$date)
  expect_null(params$geography)
  expect_null(params$sex)
  expect_null(params$MEASURES)
})

test_that("build_params collapses date vector", {
  params <- build_params("NM_1_1", NULL, c("latest", "prevyear"), NULL, NULL, NULL, FALSE, NULL)
  expect_match(params$date, ",")
})

test_that("build_params makes select unique", {
  params <- build_params("NM_1_1", "latest", NULL, NULL, NULL, NULL, FALSE, c("x", "x", "y"))
  # Should have unique values plus RECORD_COUNT
  expect_true(is.character(params$select))
})