#' Get Cache Key
#' @keywords internal
get_cache_key <- function(id, params) {
  # Create deterministic hash of query
  key_string <- paste0(id, "_", 
                       paste(names(params), params, sep = "=", collapse = "_"))
  digest::digest(key_string, algo = "md5")
}

#' Cache Data Download
#' @keywords internal
cache_data <- function(cache_key, data) {
  cache_dir <- getOption("nomisdata.cache_dir")
  if (is.null(cache_dir)) return(invisible(NULL))
  
  cache_file <- file.path(cache_dir, paste0(cache_key, ".rds"))
  saveRDS(data, cache_file, compress = TRUE)
  
  # Store metadata
  meta_file <- file.path(cache_dir, paste0(cache_key, "_meta.rds"))
  saveRDS(list(timestamp = Sys.time(), rows = nrow(data)), meta_file)
  
  invisible(cache_file)
}

#' Retrieve Cached Data
#' @keywords internal
get_cached_data <- function(cache_key, max_age_days = 30) {
  cache_dir <- getOption("nomisdata.cache_dir")
  if (is.null(cache_dir)) return(NULL)
  
  cache_file <- file.path(cache_dir, paste0(cache_key, ".rds"))
  meta_file <- file.path(cache_dir, paste0(cache_key, "_meta.rds"))
  
  if (!file.exists(cache_file)) return(NULL)
  
  # Check age
  if (file.exists(meta_file)) {
    meta <- readRDS(meta_file)
    age_days <- as.numeric(difftime(Sys.time(), meta$timestamp, units = "days"))
    
    if (age_days > max_age_days) {
      cli::cli_inform("Cached data is {round(age_days)} days old, refreshing...")
      return(NULL)
    }
    
    cli::cli_alert_success("Using cached data ({meta$rows} rows, {round(age_days, 1)} days old)")
  }
  
  readRDS(cache_file)
}