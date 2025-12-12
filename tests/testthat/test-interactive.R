# browse_dataset()
test_that("browse_dataset validates page argument", {
  expect_error(
    browse_dataset("NM_1_1", page = "invalid"),
    "should be one of"
  )
})

test_that("browse_dataset constructs dataset URL correctly", {
  expect_message(
    browse_dataset("NM_1_1", page = "dataset"),
    "datasets/NM_1_1"
  )
})

test_that("browse_dataset constructs download URL correctly", {
  expect_message(
    browse_dataset("NM_1_1", page = "download"),
    "query/select/getdatasetbytheme"
  )
})

test_that("browse_dataset constructs metadata URL correctly", {
  expect_message(
    browse_dataset("NM_1_1", page = "metadata"),
    "api/v01/dataset/NM_1_1/def.htm"
  )
})

test_that("browse_dataset defaults to dataset page", {
  expect_message(
    browse_dataset("NM_1_1"),
    "datasets/NM_1_1"
  )
})

test_that("browse_dataset shows info message in non-interactive", {
  expect_message(
    browse_dataset("NM_1_1"),
    "URL:"
  )
})

test_that("browse_dataset returns invisible TRUE", {
  result <- suppressMessages(browse_dataset("NM_1_1"))
  expect_true(result)
})

# explore_dataset()
test_that("explore_dataset requires interactive session", {
  skip_if(interactive())
  
  expect_error(
    explore_dataset("NM_1_1"),
    "interactive session"
  )
})