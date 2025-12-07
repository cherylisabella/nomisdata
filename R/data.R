#' Sample Jobseeker's Allowance Data
#' 
#' @description 
#' A small sample dataset from the Jobseeker's Allowance dataset (NM_1_1) 
#' for the UK, Great Britain, and England. Useful for offline examples and testing.
#' 
#' @format A tibble with 3 rows and 12 columns:
#' \describe{
#'   \item{GEOGRAPHY_CODE}{ONS geography code}
#'   \item{GEOGRAPHY_NAME}{Geography name (UK, GB, England)}
#'   \item{SEX}{Sex code (7 = Total)}
#'   \item{SEX_NAME}{Sex description}
#'   \item{ITEM}{Item code}
#'   \item{ITEM_NAME}{Item description}
#'   \item{MEASURES}{Measure code (20100)}
#'   \item{MEASURES_NAME}{Measure description}
#'   \item{DATE}{Date code (YYYY-MM format)}
#'   \item{DATE_NAME}{Date description}
#'   \item{OBS_VALUE}{Observed value (number of claimants)}
#'   \item{OBS_STATUS}{Observation status code}
#'   \item{RECORD_COUNT}{Number of records in query}
#' }
#' 
#' @source Nomis API: \url{https://www.nomisweb.co.uk}
#' 
#' @examples
#' data(jsa_sample)
#' head(jsa_sample)
#' summary(jsa_sample$OBS_VALUE)
"jsa_sample"

