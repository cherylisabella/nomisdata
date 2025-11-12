#' Fetch Data from Nomis
#' 
#' @description Main function to download data from Nomis datasets.
#' 
#' @param id Dataset ID (required)
#' @param time Time range using keywords or specific dates
#' @param date Specific dates (alternative to time)
#' @param geography Geography code(s)
#' @param sex Sex/gender code(s)
#' @param measures Measure code(s)
#' @param exclude_missing Remove missing values
#' @param select Column names to include
#' @param ... Additional dimension filters
#' @param .progress Show progress bar for multi-part queries
#' 
#' @return Tibble with requested data
#' @export
#' 
#' @examples
#' \donttest{
#' # Latest JSA by country
#' fetch_nomis(
#'   "NM_1_1",
#'   time = "latest",
#'   geography = "TYPE499",
#'   measures = 20100,
#'   sex = 7
#' )
#' 
#' # Specific geographies
#' fetch_nomis(
#'   "NM_1_1",
#'   date = c("latest", "prevyear"),
#'   geography = c("2092957697", "2092957698"),
#'   measures = 20100
#' )
#' }
fetch_nomis <- function(id, 
                        time = NULL,
                        date = NULL,
                        geography = NULL,
                        sex = NULL,
                        measures = NULL,
                        exclude_missing = FALSE,
                        select = NULL,
                        ...,
                        .progress = interactive()) {
  
  if (missing(id)) {
    rlang::abort("Dataset ID required")
  }
  
  # Build parameters
  params <- build_params(
    id = id,
    time = time,
    date = date,
    geography = geography,
    sex = sex,
    measures = measures,
    exclude_missing = exclude_missing,
    select = select,
    ...
  )
  
  # Check size first
  check_params <- params
  check_params$RecordLimit <- 1
  
  path <- paste0(id, ".data.csv")
  check_req <- build_request(path, check_params, format = "")
  check_resp <- execute_request(check_req)
  check_df <- parse_csv_response(check_resp)
  
  record_count <- as.numeric(check_df$RECORD_COUNT[1])
  max_rows <- if (!is.null(getOption("nomisdata.api_key"))) API_LIMIT else GUEST_LIMIT
  
  # Fetch data
  if (record_count > max_rows) {
    if (.progress) {
      rlang::inform(paste0(
        "Fetching ", scales::comma(record_count), 
        " rows in ", ceiling(record_count / max_rows), " chunks"
      ))
    }
    
    df <- fetch_paginated(id, params, record_count, max_rows, .progress)
  } else {
    req <- build_request(path, params, format = "")
    resp <- execute_request(req)
    df <- parse_csv_response(resp)
  }
  
  # Clean up
  if (!is.null(select) && !("RECORD_COUNT" %in% toupper(select))) {
    df$RECORD_COUNT <- NULL
  }
  
  df
}

#' @keywords internal
build_params <- function(id, time, date, geography, sex, measures, 
                         exclude_missing, select, ...) {
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
  
  # Sex - check which concept dataset uses
  if (!is.null(sex)) {
    # For now, assume SEX - could enhance with dataset introspection
    params$sex <- paste(sex, collapse = ",")
  }
  
  # Measures
  if (!is.null(measures)) {
    params$MEASURES <- paste(measures, collapse = ",")
  }
  
  # Exclude missing
  if (exclude_missing) {
    params$ExcludeMissingValues <- "true"
  }
  
  # Select
  if (!is.null(select)) {
    params$select <- paste(unique(c(toupper(select), "RECORD_COUNT")), collapse = ",")
  }
  
  # Additional parameters
  dots <- rlang::list2(...)
  for (nm in names(dots)) {
    if (length(dots[[nm]]) > 0) {
      params[[toupper(nm)]] <- paste(dots[[nm]], collapse = ",")
    }
  }
  
  params
}

#' @keywords internal
fetch_paginated <- function(id, params, total_rows, max_rows, show_progress) {
  offsets <- seq(0, total_rows - 1, by = max_rows)
  n_chunks <- length(offsets)
  
  results <- vector("list", n_chunks)
  path <- paste0(id, ".data.csv")
  
  if (show_progress && requireNamespace("cli", quietly = TRUE)) {
    cli::cli_progress_bar("Fetching data", total = n_chunks)
  }
  
  for (i in seq_along(offsets)) {
    chunk_params <- params
    chunk_params$RecordOffset <- format(offsets[i], scientific = FALSE)
    
    req <- build_request(path, chunk_params, format = "")
    resp <- execute_request(req)
    results[[i]] <- parse_csv_response(resp)
    
    if (show_progress) cli::cli_progress_update()
    
    # Rate limiting
    if (i < n_chunks) Sys.sleep(0.5)
  }
  
  if (show_progress) cli::cli_progress_done()
  
  dplyr::bind_rows(results)
}
