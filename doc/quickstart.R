## ----setup, include = FALSE---------------------------------------------------
knitr::opts_chunk$set(collapse = TRUE, comment = "#>")

## ----eval=FALSE---------------------------------------------------------------
# # From CRAN
# install.packages("nomisdata")
# 
# # Development version
# # install.packages("remotes")
# remotes::install_github("yourname/nomisdata")

## ----eval=FALSE---------------------------------------------------------------
# library(nomisdata)
# 
# # Search by name
# employment <- search_datasets(name = "*employment*")
# head(employment)
# 
# # Search by keywords
# census <- search_datasets(keywords = "census")

## ----eval=FALSE---------------------------------------------------------------
# # Get dataset information
# describe_dataset("NM_1_1")
# 
# # Get available concepts/dimensions
# concepts <- get_codes("NM_1_1")
# print(concepts)

## ----eval=FALSE---------------------------------------------------------------
# # Get geography codes
# geographies <- get_codes("NM_1_1", "geography")
# head(geographies)
# 
# # Search for specific geography
# london <- lookup_geography("London")
# print(london)
# 
# # Get measure codes
# measures <- get_codes("NM_1_1", "measures")
# print(measures)

## ----eval=FALSE---------------------------------------------------------------
# # Latest JSA data by country
# jsa_data <- fetch_nomis(
#   id = "NM_1_1",
#   time = "latest",
#   geography = "TYPE499",  # Countries
#   measures = 20100,        # Claimants
#   sex = 7                  # Total
# )
# 
# head(jsa_data)

## -----------------------------------------------------------------------------
library(nomisdata)
data(jsa_sample)
head(jsa_sample)

## ----eval=FALSE---------------------------------------------------------------
# # Register at: https://www.nomisweb.co.uk/myaccount/userjoin.asp
# 
# # Set for current session
# set_api_key("your-api-key")
# 
# # Or save to .Renviron for persistence
# set_api_key("your-api-key", persist = TRUE)

