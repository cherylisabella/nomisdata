library(testthat)
library(nomisdata)

# Use temp directory during tests to avoid CRAN NOTE
Sys.setenv(NOMISDATA_CACHE_DIR = file.path(tempdir(), "nomisdata"))


test_check("nomisdata")
