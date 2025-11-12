#' Get Concept Codes
#' 
#' @param id Dataset ID (required)
#' @param concept Concept name (e.g., "geography", "sex"). If NULL, returns all concepts.
#' @param type Optional type filter
#' @param search Search term (supports wildcards)
#' @param ... Additional query parameters
#' 
#' @return Tibble with codes and descriptions
#' @export
#' 
#' @examples
#' \donttest{
#' # All concepts
#' get_codes("NM_1_1")
#' 
#' # Specific concept
#' get_codes("NM_1_1", "geography")
#' 
#' # With type filter
#' get_codes("NM_1_1", "geography", "TYPE499")
#' 
#' # Search (note: may return empty if no matches)
#' get_codes("NM_1_1", "geography", search = "*manchester*")
#' }
get_codes <- function(id, concept = NULL, type = NULL, search = NULL, ...) {
  if (missing(id) || is.null(id) || id == "") {
    rlang::abort("Dataset ID is required")
  }
  
  # If no concept specified, return dimension list
  if (is.null(concept)) {
    info <- describe_dataset(id)
    
    # Try different possible paths for dimensions
    dims <- NULL
    
    # Try components.dimension (nested list column)
    if (!is.null(info$components.dimension)) {
      dims_list <- info$components.dimension
      if (is.list(dims_list) && length(dims_list) > 0) {
        dims <- tibble::as_tibble(do.call(rbind, lapply(dims_list, function(x) {
          as.data.frame(x, stringsAsFactors = FALSE)
        })))
      }
    }
    
    # Fallback: try flattening the entire info object
    if (is.null(dims) || nrow(dims) == 0) {
      # Look for any columns with "dimension" in the name
      dim_cols <- grep("dimension", names(info), value = TRUE, ignore.case = TRUE)
      if (length(dim_cols) > 0) {
        dims <- info[, dim_cols, drop = FALSE]
      }
    }
    
    # If still null, try getting directly from API with different format
    if (is.null(dims) || nrow(dims) == 0) {
      rlang::inform("Using alternative method to fetch dimensions")
      
      # Get overview instead
      overview <- dataset_overview(id, select = "Dimensions")
      
      if ("value" %in% names(overview) && length(overview$value) > 0) {
        dims_data <- overview$value[[1]]
        if (is.data.frame(dims_data)) {
          dims <- tibble::as_tibble(dims_data)
        }
      }
    }
    
    if (is.null(dims) || nrow(dims) == 0) {
      rlang::abort(
        c(
          "Could not extract dimensions from dataset",
          "i" = "Try using describe_dataset() to see the raw structure",
          "i" = "Or specify a concept name directly"
        )
      )
    }
    
    return(dims)
  }
  
  # Build request path for specific concept
  type_path <- if (!is.null(type)) paste0("/", type) else ""
  path <- paste0(id, "/", concept, type_path, "/def.sdmx.xml")
  
  # Build query parameters
  params <- list(...)
  if (!is.null(search)) {
    params$search <- paste(search, collapse = ",")
  }
  
  # Make request
  req <- build_request(path, params, format = "")
  resp <- execute_request(req)
  
  # Parse SDMX
  if (!requireNamespace("rsdmx", quietly = TRUE)) {
    rlang::abort(
      c(
        "Package 'rsdmx' is required for SDMX parsing",
        "i" = "Install it with: install.packages('rsdmx')"
      )
    )
  }
  
  url <- httr2::resp_url(resp)
  sdmx_obj <- rsdmx::readSDMX(url)
  
  if (is.null(sdmx_obj)) {
    rlang::abort("Failed to parse SDMX data from API")
  }
  
  # Convert SDMX to data frame with better error handling
  df <- tryCatch({
    # Try standard conversion
    result <- as.data.frame(sdmx_obj)
    
    # Check if result is valid
    if (is.null(result) || (!is.data.frame(result) && !is.matrix(result))) {
      # Return empty tibble with expected columns
      return(tibble::tibble(
        id = character(),
        label.en = character(),
        description.en = character()
      ))
    }
    
    # Convert to tibble
    tibble::as_tibble(result)
    
  }, error = function(e) {
    # If conversion fails, try to extract data differently
    if (inherits(sdmx_obj, "SDMXCodelist")) {
      # Extract codes manually from SDMX object
      codes_list <- slot(sdmx_obj, "Codelist")
      
      if (length(codes_list) > 0) {
        codes_data <- lapply(codes_list, function(code) {
          data.frame(
            id = if (!is.null(slot(code, "id"))) slot(code, "id") else NA_character_,
            label.en = if (!is.null(slot(code, "label"))) slot(code, "label") else NA_character_,
            description.en = if (!is.null(slot(code, "description"))) slot(code, "description") else NA_character_,
            stringsAsFactors = FALSE
          )
        })
        return(tibble::as_tibble(do.call(rbind, codes_data)))
      }
    }
    
    # If all else fails, inform user
    rlang::inform(
      c(
        "No results found or unable to parse response",
        "i" = "Search may have returned no matches",
        "i" = "Try broadening your search term"
      )
    )
    
    # Return empty tibble
    tibble::tibble(
      id = character(),
      label.en = character(),
      description.en = character()
    )
  })
  
  df
}

#' Fetch Codelist
#' 
#' @param id Dataset ID
#' @param concept Concept name
#' @param search Search term
#' 
#' @return Tibble of codes
#' @export
#' 
#' @examples
#' \donttest{
#' fetch_codelist("NM_1_1", "geography")
#' fetch_codelist("NM_1_1", "geography", "*manchester*")
#' }
fetch_codelist <- function(id, concept, search = NULL) {
  if (missing(id) || missing(concept)) {
    rlang::abort("Both 'id' and 'concept' required")
  }
  
  # Convert to codelist ID
  codelist_id <- paste0(gsub("NM", "CL", toupper(id)), "_")
  
  path <- paste0(codelist_id, concept, ".def.sdmx.xml")
  url <- paste0(NOMIS_CODELIST, path)
  
  if (!is.null(search)) {
    url <- paste0(url, "?search=", paste(search, collapse = ","))
  }
  
  if (requireNamespace("rsdmx", quietly = TRUE)) {
    df <- tibble::as_tibble(rsdmx::readSDMX(url))
    return(df)
  }
  
  rlang::abort("Package 'rsdmx' required")
}
