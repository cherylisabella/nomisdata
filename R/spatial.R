#' Fetch Spatial Data
#' 
#' @description Downloads data in KML format with spatial boundaries.
#' 
#' @param id Dataset ID
#' @param time Time period selection (same as fetch_nomis)
#' @param date Specific date selection (alternative to time)
#' @param geography Geography code(s) to filter
#' @param select Column names to include
#' @param exclude_missing Remove missing values if TRUE
#' @param ... Additional query parameters (measures, sex, etc.)
#' @param parse_sf If TRUE and sf is available, parse to sf object
#' 
#' @return KML data as text or sf object (if parse_sf = TRUE)
#' @export
#' 
#' @examples
#' \donttest{
#' # Get spatial data for regions
#' spatial_data <- fetch_spatial(
#'   "NM_1_1",
#'   time = "latest",
#'   geography = "TYPE480",
#'   measures = 20100,
#'   sex = 7
#' )
#' }
fetch_spatial <- function(id, time = NULL, date = NULL, geography = NULL, 
                          select = NULL, exclude_missing = FALSE,
                          ..., parse_sf = TRUE) {
  
  # Build parameters manually to avoid build_params issues
  params <- list()
  
  # Time/date
  if (!is.null(date)) {
    params$date <- paste(date, collapse = ",")
  } else if (!is.null(time)) {
    params$time <- paste(time, collapse = ",")
  }
  
  # Geography
  if (!is.null(geography)) {
    params$geography <- paste(geography, collapse = ",")
  }
  
  # Select
  if (!is.null(select)) {
    params$select <- paste(unique(c(toupper(select), "RECORD_COUNT")), collapse = ",")
  }
  
  # Exclude missing
  if (isTRUE(exclude_missing)) {
    params$ExcludeMissingValues <- "true"
  }
  
  # Additional parameters from ...
  dots <- rlang::list2(...)
  for (nm in names(dots)) {
    if (length(dots[[nm]]) > 0) {
      params[[toupper(nm)]] <- paste(dots[[nm]], collapse = ",")
    }
  }
  
  # Build request
  path <- paste0(id, ".data.kml")
  req <- build_request(path, params, format = "")
  resp <- execute_request(req)
  
  kml_content <- httr2::resp_body_string(resp)
  
  if (parse_sf && requireNamespace("sf", quietly = TRUE)) {
    temp_file <- tempfile(fileext = ".kml")
    writeLines(kml_content, temp_file)
    
    tryCatch({
      spatial_data <- sf::st_read(temp_file, quiet = TRUE)
      unlink(temp_file)
      return(spatial_data)
    }, error = function(e) {
      unlink(temp_file)
      cli::cli_warn("Failed to parse KML to sf: {conditionMessage(e)}")
      return(kml_content)
    })
  }
  
  kml_content
}


#' Join Geography Names
#' 
#' @description Adds human-readable geography names to data.
#' 
#' @param data Data frame with GEOGRAPHY_CODE column
#' @param dataset_id Dataset to get geography names from
#' 
#' @return Data frame with GEOGRAPHY_NAME added
#' @export
#' 
#' @examples
#' \donttest{
#' data <- fetch_nomis("NM_1_1", time = "latest", geography = "TYPE499")
#' data_with_names <- add_geography_names(data)
#' }
add_geography_names <- function(data, dataset_id = "NM_1_1") {
  if (!"GEOGRAPHY_CODE" %in% names(data)) {
    cli::cli_abort("Data must contain {.field GEOGRAPHY_CODE} column")
  }
  
  if ("GEOGRAPHY_NAME" %in% names(data)) {
    cli::cli_inform("Data already contains {.field GEOGRAPHY_NAME}")
    return(data)
  }
  
  # Get geography lookup
  geo_lookup <- get_codes(dataset_id, "geography")
  
  # Create lookup table
  if ("id" %in% names(geo_lookup) && "label.en" %in% names(geo_lookup)) {
    lookup <- data.frame(
      GEOGRAPHY_CODE = geo_lookup$id,
      GEOGRAPHY_NAME = geo_lookup$label.en,
      stringsAsFactors = FALSE
    )
  } else {
    cli::cli_warn("Could not create geography lookup")
    return(data)
  }
  
  # Join
  dplyr::left_join(data, lookup, by = "GEOGRAPHY_CODE")
}
