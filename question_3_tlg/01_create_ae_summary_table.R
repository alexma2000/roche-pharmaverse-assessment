# =====================================================================
# COMPANY: Roche - PD Data Sciences & Analytics (PDD)
# TASK: Question 3 - Table 10: Treatment-Emergent Adverse Events
# CODEBASE: Production-Grade {gtsummary} Clinical Reporting
# AUTHOR: Alex Mychlo, PhD
# DATE: September 2026
# =====================================================================

# install.packages(c("gtsummary", "pharmaverseadam", "gt", "testthat"))
library(tidyverse)
library(gtsummary)
library(pharmaverseadam)
library(gt)
library(testthat)

# Ingesting required Pharmaverse validated ADaM datasets
adae <- pharmaverseadam::adae
adsl <- pharmaverseadam::adsl

# ---------------------------------------------------------------------
# Step B: Data Pre-processing and Compliance Filtering
# ---------------------------------------------------------------------
# Enforcing mandatory FDA criteria: Analyzing only Treatment-Emergent 
# Adverse Events (TRTEMFL == "Y") as specified in the Roche protocol.
teae_data <- adae %>%
  filter(TRTEMFL == "Y") %>%
  select(ACTARM, AESOC, AETERM, USUBJID)

# Calculate exact population counts (N) per treatment arm from ADsl
arm_counts <- adsl %>%
  group_by(ACTARM) %>%
  tally()

# ---------------------------------------------------------------------
# Step C: Compiling the Summary Table Engine via {gtsummary}
# ---------------------------------------------------------------------
# Constructing a multi-level hierarchical table sorted by frequency.
ae_summary_table <- teae_data %>%
  select(AESOC, AETERM, ACTARM) %>%
  tbl_summary(
    by = ACTARM,
    sort = list(everything() ~ "frequency"), # Sort by descending frequency
    missing = "no"
  ) %>%
  add_overall(last = FALSE, col_label = "**Total**") %>%
  bold_labels() %>%
  modify_header(label = "**Primary System Organ Class / Reported Term**")

# Convert to gt object for final formatting and styling alignment
gt_table <- as_gt(ae_summary_table) %>%
  tab_header(
    title = "Table 10: Summary of Treatment-Emergent Adverse Events",
    subtitle = "Safety Population Analysis Suite"
  )

# ---------------------------------------------------------------------
# Step D: Automated Directory Verification & Safe Storage
# ---------------------------------------------------------------------
if (!dir.exists("question_3_tlg")) {
  dir.create("question_3_tlg", recursive = TRUE)
}

# Exporting final regulatory publication-grade output file
gtsummary::as_gt(ae_summary_table) %>%
  gt::gtsave("question_3_tlg/ae_summary_table.html")

print("=== FDA Summary Table Created and Saved Successfully to HTML! ===")
