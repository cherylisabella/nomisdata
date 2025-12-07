#' Aggregate Data by Geography Level
#' 
#' @importFrom rlang :=
#' @description Aggregates data to higher geography levels.
#' @param data Data frame with geography codes
#' @param to_type Target geography TYPE code
#' @param value_col Column containing values to aggregate (default: "OBS_VALUE")
#' @param fun Aggregation function (default: sum)
#' @return A tibble with aggregated data grouped by specified variables.
#' @export
#' @examples
#' data(jsa_sample)
#' aggregated <- aggregate_geography(jsa_sample, "TYPE499", "OBS_VALUE")
#' head(aggregated)
#' @importFrom rlang :=
aggregate_geography <- function(data, to_type, value_col = "OBS_VALUE", fun = sum) {
  if (!value_col %in% names(data)) { cli::cli_abort("Column {.field {value_col}} not found") }
  group_vars <- setdiff(names(data), c(value_col, "GEOGRAPHY_CODE", "GEOGRAPHY_NAME", "RECORD_COUNT"))
  data |> dplyr::group_by(dplyr::across(dplyr::all_of(group_vars))) |> dplyr::summarise(!!value_col := fun(!!rlang::sym(value_col), na.rm = TRUE), .groups = "drop")
}

#' Aggregate Time Series
#' @description Aggregates data over time periods.
#' @param data Data frame with DATE column
#' @param period Aggregation period: "year", "quarter", "month"
#' @param value_col Column containing values to aggregate
#' @param fun Aggregation function (default: mean)
#' @return A tibble with PERIOD column and aggregated values.
#' @export
#' @examples
#' data(jsa_sample)
#' \donttest{
#' if ("DATE" %in% names(jsa_sample)) {
#'   yearly_data <- aggregate_time(jsa_sample, "year", "OBS_VALUE")
#' }
#' }
aggregate_time <- function(data, period = c("year", "quarter", "month"), value_col = "OBS_VALUE", fun = mean) {
  period <- match.arg(period)
  if (!"DATE" %in% names(data)) { cli::cli_abort("Data must contain {.field DATE} column") }
  data[["PERIOD"]] <- substr(data[["DATE"]], 1, 4)
  group_vars <- setdiff(names(data), c(value_col, "DATE", "DATE_NAME", "PERIOD", "RECORD_COUNT"))
  result <- data |> dplyr::group_by(PERIOD, dplyr::across(dplyr::all_of(group_vars))) |> dplyr::summarise(!!value_col := fun(!!rlang::sym(value_col), na.rm = TRUE), .groups = "drop")
  result
}

