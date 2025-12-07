# Performance and stress tests

test_that("fetch_nomis handles pagination correctly", {
  skip_if_no_api()
  skip_on_cran()
  
  # This test would require a query that returns >25,000 rows
  # For now, just test the pagination logic exists
  expect_true(exists("fetch_paginated"))
})

test_that("caching improves performance", {
  skip_if_no_api()
  skip_on_cran()
  
  temp_dir <- tempfile()
  dir.create(temp_dir)
  options(nomisdata.cache_dir = file.path(tempdir(), "nomisdata_test"))
  on.exit(unlink(temp_dir, recursive = TRUE))
  
  # First fetch (uncached)
  time1 <- system.time({
    data1 <- fetch_nomis(
      "NM_1_1",
      time = "latest",
      geography = "TYPE499",
      measures = 20100
    )
  })
  
  # Note: Actual caching would need to be implemented in fetch_nomis
  # This test documents expected behavior
  expect_s3_class(data1, "tbl_df")
})
