#' @importFrom rlang .data abort inform warn
.onLoad <- function(libname, pkgname) {
  # Check for API key in environment
  key <- Sys.getenv("NOMIS_API_KEY")
  if (nzchar(key)) {
    options(nomisdata.api_key = key)
  }
  
  invisible()
}

#' @keywords internal
.onAttach <- function(libname, pkgname) {
  if (is.null(getOption("nomisdata.api_key"))) {
    packageStartupMessage(
      "No API key found. Guest users limited to 25,000 rows per query.\n",
      "Register at: https://www.nomisweb.co.uk/myaccount/userjoin.asp\n",
      "Then use: set_api_key('your-key')"
    )
  }
}
utils::globalVariables("PERIOD")

