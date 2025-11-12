## ----setup, include = FALSE---------------------------------------------------
knitr::opts_chunk$set(collapse = TRUE, comment = "#>")

## ----eval=FALSE---------------------------------------------------------------
# library(nomisdata)
# 
# # Get all geography types
# types <- get_codes("NM_1_1", "geography", "TYPE")
# head(types)
# 
# # Common types:
# # TYPE499 - Countries (UK, England, Wales, Scotland, NI)
# # TYPE464 - Local authorities
# # TYPE480 - Regions
# # TYPE460 - Parliamentary constituencies

## ----eval=FALSE---------------------------------------------------------------
# # Search by name
# manchester <- lookup_geography("Manchester")
# print(manchester)
# 
# # With type filter
# manchester_la <- lookup_geography("Manchester", type = "TYPE464")

## ----eval=FALSE---------------------------------------------------------------
# # Single area
# london_data <- fetch_nomis(
#   "NM_1_1",
#   time = "latest",
#   geography = "2013265927",  # London code
#   measures = 20100
# )
# 
# # Multiple areas
# cities <- c("1879048226", "1879048225")  # Manchester, Liverpool
# cities_data <- fetch_nomis(
#   "NM_1_1",
#   time = "latest",
#   geography = cities,
#   measures = 20100
# )

## ----eval=FALSE---------------------------------------------------------------
# # Get all districts in a region
# north_east <- get_codes(
#   "NM_1_1",
#   "geography",
#   search = "*north east*"
# )

