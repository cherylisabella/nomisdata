# Tests for interactive functions

# ============================================================================
# browse_dataset() tests
# ============================================================================

test_that("browse_dataset creates correct URL for dataset page", {
  expect_message(
    browse_dataset("NM_1_1", page = "dataset"),
    "www.nomisweb.co.uk/datasets/NM_1_1"
  )
})

test_that("browse_dataset creates correct URL for metadata page", {
  expect_message(
    browse_dataset("NM_1_1", page = "metadata"),
    "api/v01/dataset/NM_1_1/def.htm"
  )
})

test_that("browse_dataset creates correct URL for download page", {
  expect_message(
    browse_dataset("NM_1_1", page = "download"),
    "query/select/getdatasetbytheme"
  )
})

test_that("browse_dataset defaults to dataset page", {
  expect_message(
    browse_dataset("NM_1_1"),
    "datasets/NM_1_1"
  )
})

test_that("browse_dataset returns TRUE", {
  result <- suppressMessages(browse_dataset("NM_1_1"))
  
  expect_true(result)
})

test_that("browse_dataset shows URL in non-interactive mode", {
  expect_message(
    browse_dataset("NM_1_1"),
    "URL:"
  )
})

test_that("browse_dataset handles different dataset IDs", {
  expect_message(
    browse_dataset("NM_2_2", page = "dataset"),
    "NM_2_2"
  )
  
  expect_message(
    browse_dataset("NM_1234_5", page = "dataset"),
    "NM_1234_5"
  )
})

test_that("browse_dataset validates page argument", {
  expect_error(
    browse_dataset("NM_1_1", page = "invalid"),
    "should be one of"
  )
})

test_that("browse_dataset constructs base URL correctly", {
  expect_message(
    browse_dataset("NM_1_1"),
    "https://www.nomisweb.co.uk"
  )
})

test_that("browse_dataset concatenates ID with base URL", {
  expect_message(
    browse_dataset("TEST_123", page = "dataset"),
    "datasets/TEST_123"
  )
})

test_that("browse_dataset handles all page types", {
  pages <- c("dataset", "download", "metadata")
  
  for (page in pages) {
    expect_message(
      browse_dataset("NM_1_1", page = page),
      "URL:"
    )
  }
})

# ============================================================================
# explore_dataset() tests
# ============================================================================

test_that("explore_dataset requires interactive session", {
  skip_if(interactive())
  
  expect_error(
    explore_dataset("NM_1_1"),
    "interactive session"
  )
})

test_that("browse_dataset handles special characters in ID", {
  expect_message(
    browse_dataset("NM_1-2_3", page = "dataset"),
    "NM_1-2_3"
  )
})

test_that("browse_dataset handles lowercase page argument", {
  expect_message(
    browse_dataset("NM_1_1", page = "dataset"),
    "datasets"
  )
})