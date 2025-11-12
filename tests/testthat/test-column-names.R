# Tests for column name handling

test_that("tidy_names handles edge cases", {
  skip_if_not_installed("janitor")
  
  # Empty data frame
  df_empty <- data.frame()
  expect_equal(tidy_names(df_empty), df_empty)
  
  # Single column
  df_single <- data.frame(COLUMN_NAME = 1)
  result <- tidy_names(df_single)
  expect_equal(names(result), "column_name")
  
  # Special characters
  df_special <- data.frame(`Column-Name!` = 1, check.names = FALSE)
  result <- tidy_names(df_special)
  expect_match(names(result), "column")
})
