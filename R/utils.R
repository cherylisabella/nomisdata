#' Check if package is installed
#' @keywords internal
check_installed <- function(pkg, purpose = NULL) {
  if (!requireNamespace(pkg, quietly = TRUE)) {
    msg <- sprintf("Package '%s' required", pkg)
    if (!is.null(purpose)) {
      msg <- paste0(msg, " for ", purpose)
    }
    rlang::abort(msg, class = "nomisdata_missing_package")
  }
  invisible(TRUE)
}

#' Format numbers with comma separator
#' @keywords internal
format_number <- function(x) {
  if (requireNamespace("scales", quietly = TRUE)) {
    scales::comma(x)
  } else {
    format(x, big.mark = ",", scientific = FALSE)
  }
}

# Add digest for cache keys
#' @keywords internal
get_cache_key <- function(id, params) {
  if (requireNamespace("digest", quietly = TRUE)) {
    key_string <- paste0(id, "_", 
                         paste(names(params), params, sep = "=", collapse = "_"))
    digest::digest(key_string, algo = "md5")
  } else {
    # Fallback to simple hash
    paste0(id, "_", abs(sum(utf8ToInt(paste(params, collapse = "")))))
  }
}

