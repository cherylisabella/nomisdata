#' Enable caching for API responses
#'
#' @param path Cache directory path. If NULL, uses an appropriate default location.
#' @return Path to cache directory (invisibly)
#' @export
#' @examples
#' \donttest{
#' # Use temporary directory for cache
#' enable_cache(tempfile("nomis_cache"))
#' }
enable_cache <- function(path = NULL) {
  # CRITICAL: During R CMD check, ALWAYS use tempdir
  if (identical(Sys.getenv("NOT_CRAN"), "false") || 
      nzchar(Sys.getenv("_R_CHECK_PACKAGE_NAME_"))) {
    path <- file.path(tempdir(), "nomisdata")
  }
  
  if (is.null(path)) {
    path <- get_nomis_cache_dir()
  }
  
  # Only create directory if NOT during CRAN check
  if (!dir.exists(path) && !nzchar(Sys.getenv("_R_CHECK_PACKAGE_NAME_"))) {
    dir.create(path, recursive = TRUE, showWarnings = FALSE)
  }
  
  options(nomisdata.cache_dir = path)
  invisible(path)
}

#' Clear All Caches
#' 
#' @description Removes all cached data from disk and clears memoised functions.
#' 
#' @return Invisible TRUE. Called for side effects (clearing cache files).
#' 
#' @export
#' 
#' @examples
#' \donttest{
#' enable_cache(tempfile("nomis_cache"))
#' 
#' clear_cache()
#' }
clear_cache <- function() {
  cache_dir <- getOption("nomisdata.cache_dir")
  
  # Only proceed if cache_dir is set and exists
  if (!is.null(cache_dir) && dir.exists(cache_dir)) {
    unlink(cache_dir, recursive = TRUE)
    message("Disk cache cleared")
  }
  
  # Clear memoised functions if they exist
  if (exists("cached_metadata_fetch", envir = .GlobalEnv)) {
    memoise::forget(get("cached_metadata_fetch", envir = .GlobalEnv))
  }
  
  invisible(TRUE)
}