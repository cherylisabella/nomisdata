# Tests for tibble output consistency

test_that("all main functions return tibbles", {
  skip_if_no_api()
  skip_on_cran()
  
  # fetch_nomis
  data1 <- fetch_nomis(
    "NM_1_1",
    time = "latest",
    geography = "TYPE499",
    measures = 20100
  )
  expect_s3_class(data1, "tbl_df")
  
  # describe_dataset
  data2 <- describe_dataset("NM_1_1")
  expect_s3_class(data2, "tbl_df")
  
  # search_datasets
  data3 <- search_datasets(name = "*employment*")
  expect_s3_class(data3, "tbl_df")
})