# =====================================================================
# COMPANY: Roche - PD Data Sciences & Analytics (PDD)
# TASK: Question 3 - Visualizations Suite via {ggplot2}
# CODEBASE: Production-Grade Analytical Plots & Statistical CIs
# AUTHOR: Alex Mychlo, PhD
# DATE: September 2026
# =====================================================================

library(tidyverse)
library(pharmaverseadam)
library(ggplot2)

adae <- pharmaverseadam::adae
adsl <- pharmaverseadam::adsl

# Ensure target folder exists
if (!dir.exists("question_3_tlg")) {
  dir.create("question_3_tlg", recursive = TRUE)
}

# ---------------------------------------------------------------------
# PLOT 1: AE Severity Distribution Across Treatment Arms
# ---------------------------------------------------------------------
# Enforcing safety analysis filters and grouping categorical variables.
plot1_data <- adae %>%
  filter(TRTEMFL == "Y" & !is.na(AESEV) & !is.na(ACTARM)) %>%
  mutate(AESEV = factor(AESEV, levels = c("MILD", "MODERATE", "SEVERE")))

plot1 <- ggplot(plot1_data, aes(x = ACTARM, fill = AESEV)) +
  geom_bar(position = "stack", width = 0.6) +
  scale_fill_manual(values = c("MILD" = "#F28E2B", "MODERATE" = "#4E79A7", "SEVERE" = "#E15759")) +
  labs(
    title = "AE Severity Distribution by Treatment",
    x = "Treatment Arm",
    y = "Count of AEs",
    fill = "Severity/Intensity"
  ) +
  theme_minimal(base_size = 12) +
  theme(legend.position = "right")

ggsave("question_3_tlg/ae_severity_distribution.png", plot1, width = 8, height = 5, dpi = 300)
print("=== Plot 1 (Severity Distribution) Saved Successfully! ===")

# ---------------------------------------------------------------------
# PLOT 2: Top 10 Most Frequent AEs with Clopper-Pearson 95% CIs
# ---------------------------------------------------------------------
# Computing incidence rates relative to total N in ADSL population.
total_n <- n_distinct(adsl$USUBJID)

plot2_data <- adae %>%
  filter(TRTEMFL == "Y" & !is.na(AETERM)) %>%
  group_by(AETERM) %>%
  summarise(n_events = n_distinct(USUBJID), .groups = "drop") %>%
  mutate(
    prop = n_events / total_n,
    # Executing Clopper-Pearson exact binomial confidence interval formulas
    lower_ci = map2_dbl(n_events, total_n, ~ binom.test(.x, .y)$conf.int[1]),
    upper_ci = map2_dbl(n_events, total_n, ~ binom.test(.x, .y)$conf.int[2])
  ) %>%
  slice_max(n_events, n = 10, with_ties = FALSE) %>%
  mutate(AETERM = fct_reorder(AETERM, prop))

plot2 <- ggplot(plot2_data, aes(x = prop, y = AETERM)) +
  geom_point(size = 3, color = "black") +
  geom_errorbarh(aes(xmin = lower_ci, xmax = upper_ci), height = 0.2, color = "black", linewidth = 0.8) +
  scale_x_continuous(labels = scales::percent_format(accuracy = 1), limits = c(0, 0.35)) +
  labs(
    title = "Top 10 Most Frequent Adverse Events",
    subtitle = paste0("n = ", total_n, " subjects; 95% Clopper-Pearson CIs"),
    x = "Percentage of Patients (%)",
    y = NULL
  ) +
  theme_minimal(base_size = 12) +
  theme(
    panel.grid.minor = element_blank(),
    plot.title = element_text(face = "bold", size = 14)
  )

ggsave("question_3_tlg/top_10_frequent_aes.png", plot2, width = 8, height = 5, dpi = 300)
print("=== Plot 2 (Top 10 CIs) Saved Successfully! ===")
