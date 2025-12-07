#' Clear All Caches
#' @description Removes all cached data.
#' @return Invisible TRUE. Called for side effects.
#' @export
#' @examples
#' \donttest{
#' enable_cache()
#' clear_cache()
#' }
clear_cache <- function() {
  cache_dir <- getOption("nomisdata.cache_dir")
  if (!is.null(cache_dir) && dir.exists(cache_dir)) {
    unlink(cache_dir, recursive = TRUE)
    rlang::inform("Disk cache cleared")
  }
  if (exists("cached_metadata_fetch", envir = .GlobalEnv)) {
    memoise::forget(get("cached_metadata_fetch", envir = .GlobalEnv))
  }
  invisible(TRUE)
}
