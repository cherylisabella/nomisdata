#' Search for Datasets
#' 
#' @param name Character vector of name search terms (supports wildcards *)
#' @param keywords Character vector of keyword search terms
#' @param description Character vector of description search terms
#' @param content_type Character vector of content types
#' @param units Character vector of units
#' 
#' @return Tibble of matching datasets
#' @export
#' 
#' @examples
#' \donttest{
#' search_datasets(name = "*employment*")
#' search_datasets(keywords = "census")
#' search_datasets(name = "*benefit*", keywords = "claimants")
#' }
search_datasets <- function(name = NULL, keywords = NULL, description = NULL,
                            content_type = NULL, units = NULL) {
  # Build search terms
  searches <- list()
  if (!is.null(name)) searches$name <- paste(name, collapse = ",")
  if (!is.null(keywords)) searches$keywords <- paste(keywords, collapse = ",")
  if (!is.null(description)) searches$description <- paste(description, collapse = ",")
  if (!is.null(content_type)) searches$contenttype <- paste(content_type, collapse = ",")
  if (!is.null(units)) searches$units <- paste(units, collapse = ",")
  
  if (length(searches) == 0) {
    rlang::abort("At least one search parameter required")
  }
  
  # Build search query
  search_params <- mapply(
    \(k, v) paste0("search=", k, "-", v),
    names(searches),
    searches,
    SIMPLIFY = FALSE
  )
  
  query_string <- paste(unlist(search_params), collapse = "&")
  path <- paste0("def.sdmx.json?", query_string)
  
  req <- build_request(path, list(), format = "")
  resp <- execute_request(req)
  parsed <- parse_json_response(resp)
  
  if (is.null(parsed$structure$keyfamilies$keyfamily)) {
    rlang::inform("No datasets found")
    return(tibble::tibble())
  }
  
  tibble::as_tibble(parsed$structure$keyfamilies$keyfamily)
}

#' Describe Dataset Structure
#' 
#' @param id Dataset ID (e.g., "NM_1_1"). If NULL, returns all datasets.
#' 
#' @return Tibble with dataset metadata
#' @export
#' 
#' @examples
#' \donttest{
#' describe_dataset("NM_1_1")
#' all_datasets <- describe_dataset()
#' }
describe_dataset <- function(id = NULL) {
  path <- if (is.null(id)) {
    "def.sdmx.json"
  } else {
    paste0(id, "/def.sdmx.json")
  }
  
  req <- build_request(path, list(), format = "")
  resp <- execute_request(req)
  parsed <- parse_json_response(resp)
  
  if (is.null(id)) {
    return(tibble::as_tibble(parsed$structure$keyfamilies$keyfamily))
  }
  
  tibble::as_tibble(parsed$structure$keyfamilies$keyfamily)
}

#' Get Dataset Overview
#' 
#' @param id Dataset ID (required)
#' @param select Character vector of sections to return
#' 
#' @return Tibble with overview information
#' @export
#' 
#' @examples
#' \donttest{
#' dataset_overview("NM_1_1")
#' dataset_overview("NM_1_1", select = c("Keywords", "Units"))
#' }
dataset_overview <- function(id, select = NULL) {
  if (missing(id)) {
    rlang::abort("Dataset ID required")
  }
  
  params <- if (!is.null(select)) {
    list(select = paste(select, collapse = ","))
  } else {
    list()
  }
  
  path <- paste0(id, ".overview.json")
  req <- build_request(path, params, format = "")
  resp <- execute_request(req)
  parsed <- parse_json_response(resp)
  
  tibble::enframe(parsed$overview)
}