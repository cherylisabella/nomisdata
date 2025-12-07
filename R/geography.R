#' Look up Geography Codes
#' 
#' @description Search for UK geography codes by name. Returns matching 
#' geographies from local authorities, regions, wards, and other levels.
#' 
#' @param search_term Name or partial name to search (e.g., "London", "Manchester")
#' @param dataset_id Dataset to search in (default: "NM_1_1")
#' @param type Optional geography TYPE code to filter results
#' 
#' @return Tibble of matching geographies with codes and names
#' @export
#' 
#' @examples
#' \donttest{
#' lookup_geography("London")
#' lookup_geography("Manchester")
#' lookup_geography("Birmingham", type = "TYPE464")  # Local authorities only
#' }
lookup_geography <- function(search_term, dataset_id = "NM_1_1", type = NULL) {
  if (missing(search_term) || !nzchar(search_term)) {
    rlang::abort("Search term required")
  }
  
  # Check if rsdmx is available
  if (!requireNamespace("rsdmx", quietly = TRUE)) {
    rlang::abort(
      c(
        "Package 'rsdmx' required for geography lookup",
        "i" = "Install with: install.packages('rsdmx')"
      )
    )
  }
  
  # Use fetch_codelist to get ALL geographies with search
  search_pattern <- paste0("*", search_term, "*")
  
  tryCatch({
    matches <- fetch_codelist(dataset_id, "geography", search = search_pattern)
    
    if (nrow(matches) == 0) {
      rlang::inform(paste("No matches found for:", search_term))
    }
    
    matches
  }, error = function(e) {
    rlang::warn(
      c(
        "Geography search failed",
        "x" = conditionMessage(e),
        "i" = "Try using get_codes() for concept-level geography info"
      )
    )
    tibble::tibble()
  })
}

