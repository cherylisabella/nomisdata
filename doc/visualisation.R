## ----setup, include = FALSE---------------------------------------------------
knitr::opts_chunk$set(collapse = TRUE, comment = "#>", fig.width = 7, fig.height = 5, eval = FALSE)

## -----------------------------------------------------------------------------
# library(nomisdata)
# library(ggplot2)
# library(dplyr)
# 
# # Fetch unemployment data over time
# unemployment <- fetch_nomis(
#   "NM_1_1",
#   date = paste0("2020", c("01", "02", "03", "04", "05", "06")),
#   geography = "2092957697",  # UK
#   measures = 20201,           # Rate
#   sex = 7
# )
# 
# # Plot
# unemployment |>
#   mutate(DATE = as.Date(paste0(DATE, "-01"))) |>
#   ggplot(aes(x = DATE, y = OBS_VALUE)) +
#   geom_line(linewidth = 1, colour = "#0066cc") +
#   geom_point(size = 2, colour = "#0066cc") +
#   labs(
#     title = "UK Unemployment Rate",
#     subtitle = "Claimant Count Rate, 2020",
#     x = NULL,
#     y = "Rate (%)",
#     caption = "Source: Nomis / ONS"
#   ) +
#   theme_minimal() +
#   theme(
#     plot.title = element_text(face = "bold", size = 14),
#     panel.grid.minor = element_blank()
#   )

## -----------------------------------------------------------------------------
# # Fetch data for all regions
# regions <- fetch_nomis(
#   "NM_1_1",
#   time = "latest",
#   geography = "TYPE480",  # Regions
#   measures = 20201,       # Rate
#   sex = 7
# )
# 
# # Bar chart
# regions |>
#   arrange(desc(OBS_VALUE)) |>
#   ggplot(aes(x = reorder(GEOGRAPHY_NAME, OBS_VALUE), y = OBS_VALUE)) +
#   geom_col(fill = "#0066cc", alpha = 0.8) +
#   coord_flip() +
#   labs(
#     title = "Unemployment Rate by Region",
#     x = NULL,
#     y = "Claimant Count Rate (%)",
#     caption = "Source: Nomis / ONS"
#   ) +
#   theme_minimal()

## -----------------------------------------------------------------------------
# # Fetch data by sex
# by_sex <- fetch_nomis(
#   "NM_1_1",
#   time = "latest",
#   geography = "TYPE499",  # Countries
#   measures = 20201,
#   sex = c(5, 6)  # Male, Female
# )
# 
# # Grouped bar chart
# by_sex |>
#   ggplot(aes(x = GEOGRAPHY_NAME, y = OBS_VALUE, fill = SEX_NAME)) +
#   geom_col(position = "dodge", alpha = 0.8) +
#   scale_fill_manual(values = c("#0066cc", "#cc0066")) +
#   labs(
#     title = "Unemployment Rate by Sex and Country",
#     x = NULL,
#     y = "Rate (%)",
#     fill = "Sex",
#     caption = "Source: Nomis / ONS"
#   ) +
#   theme_minimal() +
#   theme(legend.position = "top")

## -----------------------------------------------------------------------------
# library(sf)
# 
# # Fetch spatial data
# spatial_data <- fetch_spatial(
#   "NM_1_1",
#   time = "latest",
#   geography = "TYPE480",
#   measures = 20201,
#   sex = 7
# )
# 
# # Map
# ggplot(spatial_data) +
#   geom_sf(aes(fill = OBS_VALUE), colour = "white", size = 0.3) +
#   scale_fill_viridis_c(option = "plasma") +
#   labs(
#     title = "Unemployment Rate by Region",
#     fill = "Rate (%)"
#   ) +
#   theme_void()

