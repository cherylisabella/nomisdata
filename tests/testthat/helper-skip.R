# Helper function for testing without packages
skip_if_installed <- function(pkg) {
  if (requireNamespace(pkg, quietly = TRUE)) {
    testthat::skip(paste("Package", pkg, "is installed"))
  }
}