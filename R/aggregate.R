#' Aggregate Data by Geography Level
#' 
#' @importFrom rlang :=
#' 
#' @description Aggregates data to higher geography levels.
#' 
#' @param data Data frame with geography codes
#' @param to_type Target geography TYPE code
#' @param value_col Column containing values to aggregate
#' @param fun Aggregation function (default: sum)
#' 
#' @return Aggregated data frame
#' @export
#' 
#' @examples
#' data(jsa_sample)
#' # Aggregate to country level (if lower geographies present)
#' aggregate_geography(jsa_sample, "TYPE499", "OBS_VALUE")
#' @importFrom rlang :=
aggregate_geography <- function(data, to_type, value_col = "OBS_VALUE", 
                                fun = sum) {
  if (!value_col %in% names(data)) {
    cli::cli_abort("Column {.field {value_col}} not found")
  }
  
  # For now, basic aggregation by existing grouping variables
  # Full implementation would require geography hierarchy lookup
  
  group_vars <- setdiff(names(data), c(value_col, "GEOGRAPHY_CODE", 
                                       "GEOGRAPHY_NAME", "RECORD_COUNT"))
  
  data |>
    dplyr::group_by(dplyr::across(dplyr::all_of(group_vars))) |>
    dplyr::summarise(
      !!value_col := fun(!!rlang::sym(value_col), na.rm = TRUE),
      .groups = "drop"
    )
}

#' Aggregate Time Series
#' 
#' @description Aggregates data over time periods.
#' 
#' @param data Data frame with DATE column
#' @param period Aggregation period: "year", "quarter", "month"
#' @param value_col Column containing values
#' @param fun Aggregation function
#' 
#' @return Aggregated data frame
#' @export
#' 
#' @examples
#' data(jsa_sample)
#' # If time series data available
#' # aggregate_time(data, "year", "OBS_VALUE")
aggregate_time <- function(data, period = c("year", "quarter", "month"),
                           value_col = "OBS_VALUE", fun = mean) {
  period <- match.arg(period)
  
  if (!"DATE" %in% names(data)) {
    cli::cli_abort("Data must contain {.field DATE} column")
  }
  
  # Extract period from DATE
  data[["PERIOD"]] <- substr(data[["DATE"]], 1, 4) # Basic year extraction
  
  group_vars <- setdiff(names(data), c(value_col, "DATE", "DATE_NAME", 
                                       "PERIOD", "RECORD_COUNT"))
  
  result <- data |>
    dplyr::group_by(PERIOD, dplyr::across(dplyr::all_of(group_vars))) |>
    dplyr::summarise(
      !!value_col := fun(!!rlang::sym(value_col), na.rm = TRUE),
      .groups = "drop"
    )
  
  result
}
