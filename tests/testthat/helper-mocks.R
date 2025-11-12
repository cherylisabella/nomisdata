# Mock data and helper functions for testing


# Mock CSV response for JSA data
mock_jsa_csv <- function() {
  "GEOGRAPHY_CODE,GEOGRAPHY_NAME,SEX,SEX_NAME,MEASURES,MEASURES_NAME,DATE,DATE_NAME,OBS_VALUE,OBS_STATUS,RECORD_COUNT
2092957697,United Kingdom,7,Total,20100,Persons claiming JSA,2024-01,January 2024,100000,A,3
2092957698,Great Britain,7,Total,20100,Persons claiming JSA,2024-01,January 2024,95000,A,3
2092957699,England,7,Total,20100,Persons claiming JSA,2024-01,January 2024,80000,A,3"
}

# Mock SDMX response for metadata
mock_sdmx_response <- function() {
  list(
    structure = list(
      keyfamilies = list(
        keyfamily = data.frame(
          id = "NM_1_1",
          agencyid = "NOMIS",
          version = "1.0",
          uri = "https://www.nomisweb.co.uk",
          name.en = "Jobseeker's Allowance with rates and proportions",
          stringsAsFactors = FALSE
        )
      )
    )
  )
}

# Mock geography lookup data
mock_geography_data <- function() {
  data.frame(
    id = c("2092957697", "2092957698", "2092957699"),
    label.en = c("United Kingdom", "Great Britain", "England"),
    description.en = c("UK", "GB", "ENG"),
    stringsAsFactors = FALSE
  )
}

# Skip tests if API is unavailable
skip_if_no_api <- function() {
  skip_if_offline()
  tryCatch({
    httr2::request("https://www.nomisweb.co.uk") |>
      httr2::req_timeout(5) |>
      httr2::req_perform()
  }, error = function(e) {
    skip("Nomis API unavailable")
  })
}