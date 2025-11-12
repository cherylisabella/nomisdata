#' nomisdata: Access UK Labour Market Data
#' 
#' @description 
#' Provides tools to discover, query, and download UK official statistics
#' from the Nomis API. Includes Census data, Labour Force Survey, benefit
#' statistics, and economic/demographic data.
#' 
#' @details
#' **Note**: This package is not affiliated with the Office for National 
#' Statistics or the University of Durham. It is an independent implementation
#' of the Nomis API.
#' 
#' Main functions:
#' - \code{fetch_nomis()}: Download data
#' - \code{search_datasets()}: Find datasets
#' - \code{describe_dataset()}: Get dataset structure
#' - \code{get_codes()}: Get dimension codes
#' - \code{lookup_geography()}: Find geography codes
#' 
#' For more information: https://www.nomisweb.co.uk/api/v01/help
#' 
#' @importFrom methods slot
#' @importFrom tibble tibble as_tibble enframe
#' @importFrom dplyr bind_rows
#' @importFrom rlang abort inform warn list2
#' @keywords internal
"_PACKAGE"

## usethis namespace: start
## usethis namespace: end
NULL
