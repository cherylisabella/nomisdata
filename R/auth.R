#' Set API Key
#' 
#' @description Configure your Nomis API key for increased rate limits.
#' Register at: https://www.nomisweb.co.uk/myaccount/userjoin.asp
#' 
#' @param key API key string. If NULL, will prompt or check environment.
#' @param persist If TRUE, saves to .Renviron for future sessions.
#' 
#' @return Invisible TRUE if successful
#' @export
#' 
#' @examples
#' \donttest{
#' set_api_key("your-key-here")
#' set_api_key("your-key-here", persist = TRUE)
#' }
set_api_key <- function(key = NULL, persist = FALSE) {
  if (is.null(key)) {
    key <- Sys.getenv("NOMIS_API_KEY")
    
    if (!nzchar(key)) {
      if (interactive()) {
        key <- readline("Enter API key: ")
      } else {
        rlang::abort("No API key provided and not interactive")
      }
    }
  }
  
  if (!nzchar(key)) {
    rlang::abort("Invalid API key")
  }
  
  # Set for current session
  options(nomisdata.api_key = key)
  rlang::inform("API key set for current session")
  
  # Optionally persist
  if (persist) {
    add_to_renviron(key)
  }
  
  invisible(TRUE)
}

#' @keywords internal
add_to_renviron <- function(key) {
  # Don't modify .Renviron during R CMD check
  if (nzchar(Sys.getenv("_R_CHECK_PACKAGE_NAME_"))) {
    message("API key management not available during package checks")
    return(invisible(NULL))
  }
  home <- Sys.getenv("HOME")
  renv_path <- file.path(home, ".Renviron")
  
  # Read existing lines
  if (file.exists(renv_path)) {
    lines <- readLines(renv_path, warn = FALSE)
    # Remove existing NOMIS_API_KEY entries
    lines <- lines[!grepl("^NOMIS_API_KEY=", lines)]
  } else {
    lines <- character()
  }
  
  # Add new key
  lines <- c(lines, paste0("NOMIS_API_KEY=", key))
  writeLines(lines, renv_path)
  
  rlang::inform("API key saved to .Renviron")
}

