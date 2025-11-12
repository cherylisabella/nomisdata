library(nomisdata)
library(ggplot2)
library(dplyr)
library(tidyr)
library(scales)
library(patchwork)

set_api_key("0x4dd4a559170d3ef1d8def020f1ec4dcd931c2e6e")
dir.create("inst/plots", recursive = TRUE, showWarnings = FALSE)

font_family <- "sans"

theme_grey_labels <- function() {
  theme_minimal(base_size = 12, base_family = font_family) +
    theme(
      plot.background = element_rect(fill = "transparent", color = NA),
      panel.background = element_rect(fill = "transparent", color = NA),
      plot.title = element_text(face = "bold", size = 14, color = "grey50", margin = margin(b = 8)),
      plot.subtitle = element_text(size = 11, color = "grey50", margin = margin(b = 15)),
      plot.caption = element_text(size = 9, color = "grey50", hjust = 0, 
                                  margin = margin(t = 15), lineheight = 1.3),
      axis.title.y = element_text(color = "grey50", family = font_family, size = 10),
      axis.title.x = element_text(color = "grey50", family = font_family, size = 10),
      axis.text.y = element_text(color = "grey50", family = font_family, size = 9),
      axis.text.x = element_text(color = "grey50", family = font_family, size = 9),
      legend.text = element_text(color = "grey50", family = font_family, size = 9),
      legend.title = element_text(color = "grey50", family = font_family, size = 10),
      strip.text = element_text(color = "grey50", family = font_family, size = 10),
      panel.grid.minor = element_blank(),
      panel.grid.major = element_line(color = "grey95", linewidth = 0.1),
      legend.position = "top",
      legend.background = element_rect(fill = "transparent", color = NA),
      plot.margin = margin(15, 15, 15, 15))}


# Chart 1: Current Unemployment by UK Country
uk_countries <- fetch_nomis(
  "NM_1_1",
  time = "latest", 
  geography = c("2092957699", "2092957701", "2092957700", "2092957702"),
  measures = 20100, 
  sex = 7)

date_info <- unique(uk_countries$DATE_NAME)[1]

Chart1_data <- uk_countries %>%
  filter(!is.na(OBS_VALUE)) %>%
  mutate(
    country = factor(GEOGRAPHY_NAME, levels = c("England", "Wales", "Scotland", "Northern Ireland")),
    claimants_thousands = OBS_VALUE / 1000) %>%
  arrange(desc(claimants_thousands))

p1 <- ggplot(Chart1_data, aes(x = reorder(country, claimants_thousands), 
                              y = claimants_thousands, fill = country)) +
  geom_col(show.legend = FALSE, alpha = 0.85) +
  geom_text(aes(label = paste0(comma(claimants_thousands, accuracy = 0.1), "k")),
            hjust = -0.1, fontface = "bold", size = 4, color = "grey50", family = font_family) +
  coord_flip() +
  scale_fill_manual(values = c("England" = "#1f77b4", "Wales" = "#ff7f0e", 
                               "Scotland" = "#d62728", "Northern Ireland" = "#2ca02c")) +
  scale_y_continuous(labels = comma, expand = expansion(mult = c(0, 0.15))) +
  labs(
    title = "Jobseeker's Allowance Claimants by UK Nation",
    subtitle = sprintf("Latest data: %s", date_info),
    x = NULL, 
    y = "JSA Claimants (thousands)",
    caption = sprintf("Data accessed: November 2025 | Reference period: %s\nDataset: NM_1_1 (Jobseeker's Allowance with rates and proportions)\nSource: Office for National Statistics via Nomis", date_info)
  ) +
  theme_grey_labels()

ggsave("inst/plots/01_countries_current.png", p1, width = 10, height = 6, dpi = 300, bg = "transparent")


# Chart 2: Lorenz Curve - Inequality analysis
all_local <- fetch_nomis(
  "NM_1_1",
  time = "latest", 
  geography = "TYPE464",
  measures = 20100, 
  sex = 7)

date_info_lorenz <- unique(all_local$DATE_NAME)[1]

lorenz <- all_local %>%
  filter(!is.na(OBS_VALUE), OBS_VALUE > 0) %>%
  arrange(OBS_VALUE) %>%
  mutate(
    cumsum_claimants = cumsum(OBS_VALUE),
    pct_total = cumsum_claimants / sum(OBS_VALUE) * 100,
    area_pct = row_number() / n() * 100)

top10_has <- lorenz$pct_total[ceiling(nrow(lorenz) * 0.9)]
top25_has <- lorenz$pct_total[ceiling(nrow(lorenz) * 0.75)]

p2 <- ggplot(lorenz, aes(x = area_pct, y = pct_total)) +
  geom_abline(slope = 1, intercept = 0, linetype = "dashed", color = "grey70", linewidth = 0.8) +
  geom_line(color = "#d62728", linewidth = 1.2) +
  geom_ribbon(aes(ymin = pct_total, ymax = area_pct), fill = "#d62728", alpha = 0.2) +
  annotate("text", x = 60, y = 70, 
           label = "Perfect equality line\n(if every area had\nthe same unemployment)", 
           color = "grey50", size = 3.5, family = font_family) +
  scale_x_continuous(labels = function(x) paste0(x, "%")) +
  scale_y_continuous(labels = function(x) paste0(x, "%")) +
  labs(
    title = "Geographic Concentration of Unemployment",
    subtitle = sprintf("Lorenz curve across %d UK local authorities", nrow(lorenz)),
    x = "% of Local Authorities (ranked from lowest to highest unemployment)",
    y = "Cumulative % of Total Unemployment",
    caption = sprintf("Data accessed: November 2025 | Reference period: %s\nInterpretation: Departure from diagonal indicates inequality. Top 10%% of areas contain %.0f%% of claimants\nDataset: NM_1_1 | Source: ONS via Nomis",
                      date_info_lorenz, top10_has)) +
  theme_grey_labels()

ggsave("inst/plots/02_lorenz.png", p2, width = 11, height = 8, dpi = 300, bg = "transparent")


# Chart 3: Violin + Box Plot - Distribution by Area Type
la_classified <- all_local %>%
  filter(!is.na(OBS_VALUE), OBS_VALUE > 0) %>%
  mutate(
    area = GEOGRAPHY_NAME,
    claimants = OBS_VALUE,
    region_type = case_when(
      grepl("Birmingham|Leeds|Manchester|Liverpool|Sheffield|Bristol|Newcastle|Leicester|Nottingham", 
            area, ignore.case = TRUE) ~ "Major Cities",
      grepl("Barking|Bexley|Brent|Bromley|Camden|Croydon|Ealing|Enfield|Greenwich|Hackney|Hammersmith|Haringey|Harrow|Havering|Hillingdon|Hounslow|Islington|Kensington|Kingston|Lambeth|Lewisham|Merton|Newham|Redbridge|Richmond|Southwark|Sutton|Tower Hamlets|Waltham|Wandsworth|Westminster", 
            area, ignore.case = TRUE) ~ "London Boroughs",
      grepl("Bolton|Bury|Oldham|Rochdale|Salford|Stockport|Tameside|Trafford|Wigan|Barnsley|Doncaster|Rotherham|Gateshead|South Tyneside|Sunderland|Dudley|Sandwell|Solihull|Walsall|Coventry", 
            area, ignore.case = TRUE) ~ "Metropolitan Areas",
      claimants >= 5000 ~ "Large Towns",
      claimants >= 1000 ~ "Medium Towns",
      TRUE ~ "Small Towns/Rural"))

category_summary <- la_classified %>%
  group_by(region_type) %>%
  summarize(
    n_areas = n(),
    total_claimants = sum(claimants),
    avg_claimants = mean(claimants),
    .groups = "drop") %>%
  arrange(desc(total_claimants))

p3 <- ggplot(la_classified, aes(x = region_type, y = claimants)) +
  geom_violin(aes(fill = region_type), alpha = 0.3, show.legend = FALSE) +
  geom_jitter(aes(color = region_type), width = 0.2, alpha = 0.4, size = 1.5, show.legend = FALSE) +
  geom_boxplot(width = 0.3, alpha = 0.5, outlier.shape = NA, show.legend = FALSE) +
  scale_y_log10(labels = comma, breaks = c(100, 500, 1000, 5000, 10000, 50000)) +
  scale_fill_brewer(palette = "Set2") +
  scale_color_brewer(palette = "Set2") +
  labs(
    title = "Unemployment Distribution Across Urban Hierarchy",
    subtitle = sprintf("Classification of %d local authorities by geographic type", nrow(la_classified)),
    x = "Area Type",
    y = "JSA Claimants (log scale)",
    caption = sprintf("Data accessed: November 2025 | Reference period: %s\nVisualization: Violin plot (density) + box plot (quartiles) + individual points (authorities)\nMajor cities: %d areas, avg %.0fk | London: %d areas, avg %.0fk | Metropolitan: %d areas, avg %.0fk\nDataset: NM_1_1 | Source: ONS via Nomis",
                      date_info_lorenz,
                      category_summary$n_areas[category_summary$region_type == "Major Cities"],
                      category_summary$avg_claimants[category_summary$region_type == "Major Cities"]/1000,
                      category_summary$n_areas[category_summary$region_type == "London Boroughs"],
                      category_summary$avg_claimants[category_summary$region_type == "London Boroughs"]/1000,
                      category_summary$n_areas[category_summary$region_type == "Metropolitan Areas"],
                      category_summary$avg_claimants[category_summary$region_type == "Metropolitan Areas"]/1000)
  ) +
  theme_grey_labels() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

ggsave("inst/plots/03_area_type_distribution.png", p3, width = 12, height = 8, dpi = 300, bg = "transparent")

# Chart 4: Top 20 highest unemployment areas
top20_areas <- all_local %>%
  filter(!is.na(OBS_VALUE)) %>%
  arrange(desc(OBS_VALUE)) %>%
  slice_head(n = 20) %>%
  mutate(
    area = GEOGRAPHY_NAME,
    claimants_k = OBS_VALUE / 1000)

top20_total <- sum(top20_areas$OBS_VALUE)
all_local_total <- sum(all_local$OBS_VALUE, na.rm = TRUE)
top20_percentage <- (top20_total / all_local_total) * 100
n_las_total <- nrow(all_local %>% filter(!is.na(OBS_VALUE)))
top20_pct_of_areas <- (20 / n_las_total) * 100

p4 <- ggplot(top20_areas, aes(x = reorder(area, claimants_k), y = claimants_k)) +
  geom_col(fill = "#d62728", alpha = 0.8) +
  geom_text(aes(label = comma(claimants_k, accuracy = 0.1)),
            hjust = -0.1, fontface = "bold", size = 3, color = "grey50", family = font_family) +
  coord_flip() +
  scale_y_continuous(labels = comma, expand = expansion(mult = c(0, 0.12))) +
  labs(
    title = "Local Authorities with Highest JSA Claimants",
    subtitle = "Note: JSA only; does not include Universal Credit claimants",
    x = NULL, 
    y = "JSA Claimants (thousands)",
    caption = sprintf("Data accessed: November 2025 | Reference period: %s\nThese 20 areas (%.1f%% of %d local authorities) contain %.1f%% of total UK unemployment\nDataset: NM_1_1 | Source: ONS via Nomis", 
                      date_info_lorenz, top20_pct_of_areas, n_las_total, top20_percentage)) +
  theme_grey_labels() +
  theme(axis.text.y = element_text(size = 9, color = "grey50"))

ggsave("inst/plots/04_top20_worst_areas.png", p4, width = 10, height = 9, dpi = 300, bg = "transparent")


# Chart 5: Gender gap analysis
gender_countries <- fetch_nomis(
  "NM_1_1",
  time = "latest",
  geography = c("2092957699", "2092957701", "2092957700", "2092957702"),
  measures = 20100, 
  sex = c(5, 6))

ref_date_gender <- unique(gender_countries$DATE_NAME)[1]

Chart5_data <- gender_countries %>%
  filter(!is.na(OBS_VALUE)) %>%
  distinct(GEOGRAPHY_CODE, SEX, .keep_all = TRUE) %>%
  mutate(
    country = factor(GEOGRAPHY_NAME, levels = c("England", "Wales", "Scotland", "Northern Ireland")),
    sex = SEX_NAME,
    claimants_k = OBS_VALUE / 1000)

# Calculate gender gaps
gender_gaps <- Chart5_data %>%
  select(country, sex, claimants_k) %>%
  pivot_wider(names_from = sex, values_from = claimants_k) %>%
  mutate(gap_k = Male - Female,
         gap_pct = (Male - Female) / Female * 100)

p5 <- ggplot(Chart5_data, aes(x = country, y = claimants_k, fill = sex)) +
  geom_col(position = position_dodge(width = 0.9), alpha = 0.85) +
  geom_text(
    aes(label = paste0(comma(claimants_k, accuracy = 0.1), "k")),
    position = position_dodge(width = 0.9),
    vjust = -0.3,
    color = "grey50",
    size = 3.5,
    fontface = "bold",
    family = font_family
  ) +
  scale_fill_manual(values = c("Male" = "#1f77b4", "Female" = "#f28db0")) +
  scale_y_continuous(labels = comma, expand = expansion(mult = c(0, 0.15))) +
  labs(
    title = "Gender Disparities in Unemployment Across UK Nations",
    subtitle = sprintf("JSA claimants by sex | Reference period: %s", ref_date_gender),
    x = NULL,
    y = "JSA Claimants (thousands)",
    fill = NULL,
    caption = sprintf("Data accessed: November 2025 | Reference period: %s\nMale unemployment exceeds female across all nations (England: +%.0fk, Wales: +%.0fk, Scotland: +%.0fk, NI: +%.0fk)\nDataset: NM_1_1 | Source: ONS via Nomis",
                      ref_date_gender,
                      gender_gaps$gap_k[gender_gaps$country == "England"],
                      gender_gaps$gap_k[gender_gaps$country == "Wales"],
                      gender_gaps$gap_k[gender_gaps$country == "Scotland"],
                      gender_gaps$gap_k[gender_gaps$country == "Northern Ireland"])
  ) +
  theme_grey_labels()

ggsave("inst/plots/05_gender_gap.png", p5, width = 11, height = 7, dpi = 300, bg = "transparent")


# Chart 6: London Boroughs
london_boroughs <- fetch_nomis(
  "NM_1_1",
  time = "latest",
  geography = "TYPE464",
  measures = 20100,
  sex = 7)

date_info_london <- unique(london_boroughs$DATE_NAME)[1]

Chart6_data <- london_boroughs %>%
  filter(!is.na(OBS_VALUE)) %>%
  filter(grepl("Barking|Barnet|Bexley|Brent|Bromley|Camden|Croydon|Ealing|Enfield|Greenwich|Hackney|Hammersmith|Haringey|Harrow|Havering|Hillingdon|Hounslow|Islington|Kensington|Kingston|Lambeth|Lewisham|Merton|Newham|Redbridge|Richmond|Southwark|Sutton|Tower Hamlets|Waltham|Wandsworth|Westminster|City of London", 
               GEOGRAPHY_NAME, ignore.case = TRUE)) %>%
  mutate(
    borough = gsub(" London Boro", "", GEOGRAPHY_NAME),
    borough = gsub(" \\(City of London\\)", "", borough),
    claimants_k = OBS_VALUE / 1000) %>%
  arrange(desc(claimants_k))

max_borough <- Chart6_data$borough[1]
min_borough <- Chart6_data$borough[nrow(Chart6_data)]
ratio <- Chart6_data$claimants_k[1] / Chart6_data$claimants_k[nrow(Chart6_data)]

p6 <- ggplot(Chart6_data, aes(x = reorder(borough, claimants_k), y = claimants_k)) +
  geom_col(aes(fill = claimants_k), alpha = 0.85, show.legend = FALSE) +
  geom_text(aes(label = comma(claimants_k, accuracy = 0.1)),
            hjust = -0.1, size = 2.8, color = "grey50", 
            family = font_family, fontface = "bold") +
  coord_flip() +
  scale_fill_gradient(low = "#fee090", high = "#d73027") +
  scale_y_continuous(labels = comma, expand = expansion(mult = c(0, 0.15))) +
  labs(
    title = "London Borough JSA Claimants",
    subtitle = sprintf("Variation across London's 33 boroughs | JSA only, Universal Credit unemployment not included", date_info_london),
    x = NULL,
    y = "JSA Claimants (thousands)",
    caption = sprintf("Data accessed: November 2025 | Reference period: %s\n%s has %.1fx more claimants than %s, demonstrating stark intra-metropolitan inequality\nDataset: NM_1_1 | Source: ONS via Nomis",
                      date_info_london, max_borough, ratio, min_borough)) +
  theme_grey_labels() +
  theme(axis.text.y = element_text(size = 8, color = "grey50"))

ggsave("inst/plots/06_london_boroughs.png", p6, width = 10, height = 10, dpi = 300, bg = "transparent")


# Chart 7: Year-On-Year Change
countries_latest <- fetch_nomis("NM_1_1", time = "latest", geography = c("2092957699", "2092957701", "2092957700", "2092957702"),
  measures = 20100, sex = 7)

countries_prevyear <- fetch_nomis(
  "NM_1_1", time = "prevyear",
  geography = c("2092957699", "2092957701", "2092957700", "2092957702"),
  measures = 20100, sex = 7)

date_latest <- unique(countries_latest$DATE_NAME)[1]
date_previous <- unique(countries_prevyear$DATE_NAME)[1]

Chart7_data <- countries_latest %>%
  select(code = GEOGRAPHY_CODE, country = GEOGRAPHY_NAME, current = OBS_VALUE) %>%
  inner_join(
    countries_prevyear %>% select(code = GEOGRAPHY_CODE, previous = OBS_VALUE),
    by = "code") %>%
  filter(!is.na(current), !is.na(previous), previous > 0) %>%
  mutate(
    change_pct = ((current - previous) / previous) * 100,
    direction = if_else(change_pct > 0, "Increase", "Decrease"))

p7 <- ggplot(Chart7_data, aes(x = reorder(country, change_pct), y = change_pct, fill = direction)) +
  geom_col(alpha = 0.85) +
  geom_hline(yintercept = 0, color = "grey30", linewidth = 0.8) +
  geom_text(aes(label = sprintf("%+.1f%%", change_pct)),
            hjust = if_else(Chart7_data$change_pct > 0, -0.2, 1.2),
            fontface = "bold", size = 4, color = "grey50", family = font_family) +
  coord_flip() +
  scale_fill_manual(values = c("Decrease" = "#2ca02c", "Increase" = "#d62728")) +
  scale_y_continuous(
    labels = function(x) paste0(ifelse(x > 0, "+", ""), x, "%"),
    expand = expansion(mult = c(0.2, 0.2))
  ) +
  labs(
    title = "Temporal Dynamics: Year-on-Year Unemployment Change",
    subtitle = sprintf("Comparing %s vs %s", date_latest, date_previous),
    x = NULL,
    y = "Year-on-Year Change (%)",
    fill = NULL,
    caption = sprintf("Data accessed: November 2025 | Comparison: %s vs %s\nGreen indicates improvement (fewer claimants); Red indicates deterioration (more claimants)\nDataset: NM_1_1 | Source: ONS via Nomis",
                      date_latest, date_previous)) +
  theme_grey_labels()

ggsave("inst/plots/07_yoy_change_countries.png", p7,
       width = 10, height = 6, dpi = 300, bg = "transparent")


# Chart 8: BEST VS WORST PERFORMERS (LOCAL AUTHORITIES)

las_latest <- fetch_nomis("NM_1_1", time = "latest", geography = "TYPE464", measures = 20100, sex = 7)
las_prevyear <- fetch_nomis("NM_1_1", time = "prevyear", geography = "TYPE464", measures = 20100, sex = 7)

performance <- las_latest %>%
  select(code = GEOGRAPHY_CODE, name = GEOGRAPHY_NAME, current = OBS_VALUE) %>%
  inner_join(
    las_prevyear %>% select(code = GEOGRAPHY_CODE, previous = OBS_VALUE), 
    by = "code"
  ) %>%
  filter(!is.na(current), !is.na(previous), previous > 100) %>%
  mutate(change_pct = ((current - previous) / previous) * 100) %>%
  arrange(change_pct)

best_worst <- bind_rows(
  performance %>% slice_head(n = 10) %>% mutate(group = "Top 10 Improvers"),
  performance %>% slice_tail(n = 10) %>% mutate(group = "Top 10 Decliners")
)

p8 <- ggplot(best_worst, aes(x = reorder(name, change_pct), y = change_pct, fill = group)) +
  geom_col(alpha = 0.85) +
  geom_hline(yintercept = 0, color = "grey30", linewidth = 0.5) +
  coord_flip() +
  scale_fill_manual(values = c("Top 10 Improvers" = "#2ca02c", "Top 10 Decliners" = "#d62728")) +
  scale_y_continuous(
    labels = function(x) paste0(ifelse(x > 0, "+", ""), round(x, 1), "%"),
    expand = expansion(mult = c(0.15, 0.15))) +
  labs(
    title = "Local Authority Performance: Success Stories vs Struggling Areas",
    subtitle = sprintf("Year-on-year change leaders and laggards | %s vs %s", date_latest, date_previous),
    x = NULL,
    y = "Year-on-Year Change (%)",
    fill = NULL,
    caption = sprintf("Data accessed: November 2025 | Comparison: %s vs %s\nImprovers: Largest decreases in unemployment | Decliners: Largest increases in unemployment\nDataset: NM_1_1 | Source: ONS via Nomis",
                      date_latest, date_previous)) +
  theme_grey_labels() +
  theme(axis.text.y = element_text(size = 9, color = "grey50"))

ggsave("inst/plots/08_best_worst_performers.png", p8,
       width = 10, height = 9, dpi = 300, bg = "transparent")

# =============================================================================
# Chart 9: 4-Panel Dashboard

# Panel A: Current levels
pA <- ggplot(Chart1_data, aes(x = reorder(country, -claimants_thousands), 
                              y = claimants_thousands, fill = country)) +
  geom_col(show.legend = FALSE, alpha = 0.85) +
  scale_fill_manual(values = c("England" = "#1f77b4", "Wales" = "#ff7f0e", 
                               "Scotland" = "#d62728", "Northern Ireland" = "#2ca02c")) +
  scale_y_continuous(labels = comma) +
  labs(title = "Current Levels", x = NULL, y = "Claimants (k)") +
  theme_grey_labels() + 
  theme(plot.title = element_text(size = 11, color = "grey50"))

# Panel B: Gender split
pB <- ggplot(Chart5_data, aes(x = country, y = claimants_k, fill = sex)) +
  geom_col(position = position_dodge(width = 0.9), alpha = 0.85) +
  scale_fill_manual(values = c("Male" = "#1f77b4", "Female" = "#ff7f0e")) +
  scale_y_continuous(labels = comma) +
  labs(title = "Gender Split", x = NULL, y = "Claimants (k)", fill = NULL) +
  theme_grey_labels() + 
  theme(plot.title = element_text(size = 11, color = "grey50"), 
        legend.position = "right")

# Panel C: YoY Change
pC <- ggplot(Chart7_data, aes(x = reorder(country, change_pct), y = change_pct, fill = direction)) +
  geom_col(show.legend = FALSE, alpha = 0.85) +
  geom_hline(yintercept = 0, color = "grey50", linetype = "dashed", linewidth = 0.5) +
  scale_fill_manual(values = c("Decrease" = "#2ca02c", "Increase" = "#d62728")) +
  coord_flip() +
  scale_y_continuous(labels = function(x) paste0(ifelse(x > 0, "+", ""), round(x, 1), "%")) +
  labs(title = "Year-on-Year Change", x = NULL, y = "Change (%)") +
  theme_grey_labels() + 
  theme(plot.title = element_text(size = 11, color = "grey50"))

# Panel D: Top local authorities
top_las <- all_local %>%
  arrange(desc(OBS_VALUE)) %>%
  slice_head(n = 8) %>%
  mutate(
    area = gsub(" London Boro", "", GEOGRAPHY_NAME),
    claimants_k = OBS_VALUE / 1000)

pD <- ggplot(top_las, aes(x = reorder(area, claimants_k), y = claimants_k)) +
  geom_col(fill = "#d62728", alpha = 0.85) +
  coord_flip() +
  scale_y_continuous(labels = comma) +
  labs(title = "Top 8 Local Authorities", x = NULL, y = "Claimants (k)") +
  theme_grey_labels() + 
  theme(plot.title = element_text(size = 11, color = "grey50"),
        axis.text.y = element_text(size = 8, color = "grey50"))

dashboard <- (pA + pB) / (pC + pD) +
  plot_annotation(
    title = "UK Unemployment Dashboard: Multi-Dimensional Overview",
    subtitle = sprintf("Comprehensive analysis across nations | Data: %s", date_info),
    caption = sprintf("Data accessed: November 2025 | Reference period: %s\nDataset: NM_1_1 | Source: ONS via Nomis", date_info),
    theme = theme(
      plot.title = element_text(size = 16, face = "bold", color = "grey50", family = font_family),
      plot.subtitle = element_text(size = 12, color = "grey50", family = font_family),
      plot.caption = element_text(size = 9, color = "grey50", family = font_family),
      plot.background = element_rect(fill = "transparent", color = NA)))

ggsave("inst/plots/09_nations_dashboard.png", dashboard, 
       width = 14, height = 10, dpi = 300, bg = "transparent")


# Scatterplot: Local Authority Scale vs Change
scatter_data <- las_latest %>%
  select(code = GEOGRAPHY_CODE, area = GEOGRAPHY_NAME, current = OBS_VALUE) %>%
  inner_join(
    las_prevyear %>% select(code = GEOGRAPHY_CODE, previous = OBS_VALUE),
    by = "code") %>%
  filter(!is.na(current), !is.na(previous), previous > 100) %>%
  mutate(
    change_pct = (current - previous) / previous * 100,
    claimants_k = current / 1000,
    size_category = case_when(
      current >= 10000 ~ "Large (10k+)",
      current >= 5000 ~ "Medium (5-10k)",
      current >= 1000 ~ "Small (1-5k)",
      TRUE ~ "Very Small (<1k)"))

cor_value <- cor(log10(scatter_data$current), scatter_data$change_pct, use = "complete.obs")

p10 <- ggplot(scatter_data, aes(x = claimants_k, y = change_pct)) +
  geom_point(aes(color = size_category), alpha = 0.5, size = 2) +
  geom_hline(yintercept = 0, color = "grey50", linetype = "dashed") +
  geom_smooth(method = "loess", se = TRUE, color = "#d62728", fill = "#d62728", alpha = 0.2) +
  scale_x_log10(labels = comma, breaks = c(0.1, 0.5, 1, 5, 10, 50)) +
  scale_color_brewer(palette = "Set2", name = "Area Size") +
  labs(
    title = "Does Unemployment Concentration Predict Growth Rates?",
    subtitle = sprintf("Relationship between current claimant levels and year-on-year change | Comparing %s vs %s", date_latest, date_previous),
    x = "Current JSA Claimants (thousands, log scale)",
    y = "Year-on-Year Change (%)",
    caption = sprintf("Data accessed: November 2025 | Comparison: %s vs %s\nEach point represents a local authority; color indicates absolute unemployment size\nNon-linear relationship (LOESS curve) shows complex dynamics between scale and change\nDataset: NM_1_1 | Source: ONS via Nomis", date_latest, date_previous)
  ) +
  theme_grey_labels()

ggsave("inst/plots/10_scale_vs_change_scatter.png", p10, width = 11, height = 8, dpi = 300, bg = "transparent")


# Summary Statistics
cat("\nNational Statistics:\n")
Chart1_data %>%
  summarise(
    total_claimants = sum(claimants_thousands) * 1000,
    mean_claimants = mean(claimants_thousands) * 1000,
    min_claimants = min(claimants_thousands) * 1000,
    max_claimants = max(claimants_thousands) * 1000
  ) %>%
  print()

cat("\nLocal Authority Distribution:\n")
all_local %>%
  filter(!is.na(OBS_VALUE), OBS_VALUE > 0) %>%
  summarise(
    n_authorities = n(),
    total_claimants = sum(OBS_VALUE),
    mean_claimants = mean(OBS_VALUE),
    median_claimants = median(OBS_VALUE),
    sd_claimants = sd(OBS_VALUE),
    min_claimants = min(OBS_VALUE),
    max_claimants = max(OBS_VALUE),
    p10 = quantile(OBS_VALUE, 0.1),
    p90 = quantile(OBS_VALUE, 0.9)
  ) %>%
  print()

cat("\nGender Gap Statistics:\n")
Chart5_data %>%
  group_by(country) %>%
  summarise(
    male = claimants_k[sex == "Male"],
    female = claimants_k[sex == "Female"],
    gap = male - female,
    gap_pct = (male - female) / female * 100,
    .groups = "drop"
  ) %>%
  print()

