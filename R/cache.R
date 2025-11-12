#' Enable disk caching
#' 
#' @param path Directory for cache. Defaults to user cache directory.
#' @return Invisible TRUE
#' @export
#' 
#' @examples
#' \dontrun{
#' enable_cache()
#' # Custom location
#' enable_cache("~/my_nomis_cache")
#' }
enable_cache <- function(path = NULL) {
  if (is.null(path)) {
    if (!requireNamespace("rappdirs", quietly = TRUE)) {
      rlang::abort("Package 'rappdirs' required for default cache location")
    }
    path <- rappdirs::user_cache_dir("nomisdata")
  }
  
  dir.create(path, showWarnings = FALSE, recursive = TRUE)
  options(nomisdata.cache_dir = path)
  rlang::inform(paste("Cache enabled at:", path))
  invisible(TRUE)
}

#' Clear all caches
#' @export
#' @examples
#' \dontrun{
#' clear_cache()
#' }
clear_cache <- function() {
  cache_dir <- getOption("nomisdata.cache_dir")
  if (!is.null(cache_dir) && dir.exists(cache_dir)) {
    unlink(cache_dir, recursive = TRUE)
    rlang::inform("Disk cache cleared")
  }
  
  # Clear memoised functions
  if (exists("cached_metadata_fetch", envir = .GlobalEnv)) {
    memoise::forget(get("cached_metadata_fetch", envir = .GlobalEnv))
  }
  
  invisible(TRUE)
}