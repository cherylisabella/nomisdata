## ----setup, include = FALSE---------------------------------------------------
knitr::opts_chunk$set(collapse = TRUE, comment = "#>", eval = FALSE)

## -----------------------------------------------------------------------------
# library(nomisdata)
# 
# # This will automatically chunk if >25,000 rows (guest) or >100,000 rows (API key)
# large_data <- fetch_nomis(
#   "NM_1_1",
#   time = c("first", "latest"),  # All time periods
#   geography = "TYPE464",         # All local authorities
#   measures = 20100
# )

## -----------------------------------------------------------------------------
# # Enable caching
# enable_cache("~/my_nomis_cache")
# 
# # First call downloads from API
# data1 <- fetch_nomis("NM_1_1", time = "latest", geography = "TYPE499")
# 
# # Second call uses cache
# data2 <- fetch_nomis("NM_1_1", time = "latest", geography = "TYPE499")
# 
# # Clear when needed
# clear_cache()

## -----------------------------------------------------------------------------
# library(future)
# plan(multisession, workers = 4)
# 
# # Define queries
# queries <- list(
#   list(geography = "2092957697", time = "2020"),
#   list(geography = "2092957698", time = "2020"),
#   list(geography = "2092957699", time = "2020")
# )
# 
# # Fetch in parallel (implementation would use future_map)

## -----------------------------------------------------------------------------
# # Employment data
# employment <- fetch_nomis(
#   "NM_168_1",
#   time = "latest",
#   geography = "TYPE499"
# )
# 
# # Benefits data
# benefits <- fetch_nomis(
#   "NM_1_1",
#   time = "latest",
#   geography = "TYPE499"
# )
# 
# # Join by geography
# library(dplyr)
# combined <- employment |>
#   inner_join(benefits, by = "GEOGRAPHY_CODE", suffix = c("_emp", "_ben"))

