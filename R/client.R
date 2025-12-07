#' Build HTTP request
#' @keywords internal
#' @importFrom httr2 request req_url_query req_user_agent req_retry req_error req_perform
build_request <- function(path, params = list(), format = "csv") {
  # Remove NULL parameters
  params <- params[!vapply(params, is.null, logical(1))]
  
  # Add API key if available
  api_key <- getOption("nomisdata.api_key")
  if (!is.null(api_key)) {
    params$uid <- api_key
  }
  
  # Construct URL
  url_path <- if (grepl("\\.", path)) {
    paste0(NOMIS_DATASET, path)
  } else {
    paste0(NOMIS_DATASET, path, if (nzchar(format)) paste0(".", format) else "")
  }
  
  req <- httr2::request(url_path) |>
    httr2::req_url_query(!!!params) |>
    httr2::req_user_agent("nomisdata/1.0.0 (https://github.com/yourname/nomisdata)") |>
    httr2::req_retry(
      max_tries = 3,
      is_transient = \(resp) httr2::resp_status(resp) %in% c(429, 503, 504),
      backoff = ~ 2 ^ .x
    ) |>
    httr2::req_error(body = handle_error_body)
  
  req
}

#' @keywords internal
handle_error_body <- function(resp) {
  status <- httr2::resp_status(resp)
  
  # Check if body is empty
  if (!httr2::resp_has_body(resp)) {
    return(paste0("API error [", status, "]: No response body"))
  }
  
  body <- tryCatch(
    httr2::resp_body_string(resp),
    error = function(e) ""
  )
  
  if (status == 429) {
    return("Rate limit exceeded. Try smaller queries or wait before retrying.")
  }
  
  if (status == 400) {
    return(paste0("Invalid parameters: ", body))
  }
  
  paste0("API error [", status, "]: ", if (nzchar(body)) body else "Unknown error")
}

#' Execute request
#' @keywords internal
execute_request <- function(req) {
  resp <- httr2::req_perform(req)
  resp
}

#' Parse CSV response
#' @keywords internal
parse_csv_response <- function(resp) {
  if (!httr2::resp_has_body(resp)) {
    rlang::abort("Response has no body", class = "nomisdata_empty_response")
  }
  
  content <- httr2::resp_body_string(resp)
  
  # Use readr for faster parsing
  if (requireNamespace("readr", quietly = TRUE)) {
    df <- readr::read_csv(content, show_col_types = FALSE)
  } else {
    df <- utils::read.csv(text = content, stringsAsFactors = FALSE)
  }
  
  # Convert OBS_VALUE to numeric
  if ("OBS_VALUE" %in% names(df)) {
    df$OBS_VALUE <- as.numeric(df$OBS_VALUE)
  }
  
  tibble::as_tibble(df)
}

#' Parse JSON response
#' @keywords internal
#' @importFrom jsonlite fromJSON
parse_json_response <- function(resp) {
  content <- httr2::resp_body_string(resp)
  parsed <- jsonlite::fromJSON(content, flatten = TRUE)
  parsed
}

