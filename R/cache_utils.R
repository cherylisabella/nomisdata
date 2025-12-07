# Cache directory helper function for CRAN compliance
#
# This function returns an appropriate cache directory:
# - During R CMD check: uses tempdir() (does not create it)
# - Normal use: uses user cache directory or environment variable
#
# @return Character string path to cache directory
# @keywords internal
get_nomis_cache_dir <- function() {
  # During R CMD check, use temp directory - DO NOT CREATE
  if (identical(Sys.getenv("NOT_CRAN"), "false") || 
      nzchar(Sys.getenv("_R_CHECK_PACKAGE_NAME_"))) {
    # Return tempdir path but do NOT create subdirectories
    return(file.path(tempdir(), "nomisdata"))
  }
  
  # Check for user-set environment variable
  cache_dir <- Sys.getenv("NOMISDATA_CACHE_DIR")
  if (nzchar(cache_dir)) {
    return(cache_dir)
  }
  
  # Use tools::R_user_dir (available in R >= 4.0)
  if (getRversion() >= "4.0.0") {
    cache_dir <- tools::R_user_dir("nomisdata", "cache")
    return(cache_dir)
  }
  
  # Fallback to rappdirs if available
  if (requireNamespace("rappdirs", quietly = TRUE)) {
    cache_dir <- rappdirs::user_cache_dir("nomisdata")
    return(cache_dir)
  }
  
  # Final fallback
  return(file.path(tempdir(), "nomisdata"))
}

