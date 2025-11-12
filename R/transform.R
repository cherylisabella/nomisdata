#' Tidy Column Names
#' 
#' @param df Data frame
#' @param style Naming style: "snake_case", "camelCase", "period.case"
#' 
#' @return Data frame with tidied names
#' @export
#' 
#' @examples
#' df <- data.frame(GEOGRAPHY_NAME = "UK", OBS_VALUE = 100)
#' tidy_names(df)
tidy_names <- function(df, style = "snake_case") {
  if (!requireNamespace("janitor", quietly = TRUE)) {
    rlang::warn("Package 'janitor' not available, returning unchanged")
    return(df)
  }
  
  if (style == "snake_case") {
    names(df) <- janitor::make_clean_names(names(df))
  } else if (style == "camelCase") {
    names(df) <- janitor::make_clean_names(names(df), case = "small_camel")
  } else if (style == "period.case") {
    names(df) <- janitor::make_clean_names(names(df))
    names(df) <- gsub("_", ".", names(df))
  }
  
  df
}