# Tests for interactive functions

test_that("browse_dataset creates correct URLs", {
  expect_message(
    browse_dataset("NM_1_1", page = "dataset"),
    "www.nomisweb.co.uk/datasets/NM_1_1"
  )
  
  expect_message(
    browse_dataset("NM_1_1", page = "metadata"),
    "api/v01/dataset/NM_1_1/def.htm"
  )
})

test_that("explore_dataset requires interactive session", {
  skip_if(interactive())
  
  expect_error(
    explore_dataset("NM_1_1"),
    "interactive session"
  )
})