#' Sample Jobseeker's Allowance Data
#' 
#' @description 
#' A small sample dataset from the Jobseeker's Allowance dataset (NM_1_1) for the UK, Great Britain, and England. Useful for offline examples and testing.
#' 
#' @format A tibble with columns:
#' \describe{
#'   \item{GEOGRAPHY_CODE}{ONS geography code}
#'   \item{GEOGRAPHY_NAME}{Geography name}
#'   \item{SEX}{Sex code (5=Male, 6=Female, 7=Total)}
#'   \item{SEX_NAME}{Sex description}
#'   \item{ITEM}{Item code}
#'   \item{ITEM_NAME}{Item description}
#'   \item{MEASURES}{Measure code}
#'   \item{MEASURES_NAME}{Measure description}
#'   \item{DATE}{Date code}
#'   \item{DATE_NAME}{Date description}
#'   \item{OBS_VALUE}{Observed value}
#'   \item{OBS_STATUS}{Observation status}
#' }
#' 
#' @source Nomis API: \url{https://www.nomisweb.co.uk}
"jsa_sample"
