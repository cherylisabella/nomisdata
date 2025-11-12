# Tests for optional dependencies

test_that("package works without optional dependencies", {
  # Test basic functionality without rsdmx
  expect_error(
    describe_dataset("NM_1_1"),
    NA
  )
})

test_that("package suggests correct packages", {
  desc_file <- system.file("DESCRIPTION", package = "nomisdata")
  if (file.exists(desc_file)) {
    desc <- read.dcf(desc_file)
    suggests <- desc[1, "Suggests"]
    
    # Check key suggested packages are listed
    expect_match(suggests, "rsdmx", ignore.case = TRUE)
    expect_match(suggests, "testthat", ignore.case = TRUE)
  }
})
