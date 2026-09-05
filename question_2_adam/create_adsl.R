# =====================================================================
# COMPANY: Roche - PD Data Sciences & Analytics (PDD)
# POSITION: Analytical Data Science Programmer
# TASK: Question 2 - Creation of ADaM ADSL Dataset via {admiral}
# CODEBASE: Production-Grade Regulatory Compliant Framework (2026 Engine)
# AUTHOR: Alex Mychlo, PhD
# DATE: September 2026
# =====================================================================

# ---------------------------------------------------------------------
# Step A: Environment Ingestion and Dependencies
# ---------------------------------------------------------------------
# If packages are not installed, run:
# install.packages(c("admiral", "pharmaversesdtm", "testthat", "lubridate"))

library(tidyverse)
library(admiral)
library(pharmaversesdtm)
library(testthat)
library(lubridate)

# Input datasets directly referenced from the pharmaversesdtm clinical stack
dm <- pharmaversesdtm::dm
vs <- pharmaversesdtm::vs
ex <- pharmaversesdtm::ex
ds <- pharmaversesdtm::ds
ae <- pharmaversesdtm::ae

# ---------------------------------------------------------------------
# Step B: Core Baseline Ingestion and ITTFL Derivation
# ---------------------------------------------------------------------
# Initializing the ADSL dataset matrix using Demographics (DM) as the root node.
# Deriving ITTFL: "Y" if ARM is populated (randomized), else "N".
adsl_start <- dm %>%
  mutate(
    ITTFL = if_else(!is.na(ARM) & ARM != "" & ARM != "SCREEN FAILURE", "Y", "N")
  )

# ---------------------------------------------------------------------
# Step C: Age Categorization Profiles (AGEGR9 & AGEGR9N)
# ---------------------------------------------------------------------
adsl_age <- adsl_start %>%
  mutate(
    AGEGR9N = case_when(
      AGE < 18  ~ 1,
      AGE >= 18 & AGE <= 50 ~ 2,
      AGE > 50  ~ 3,
      TRUE      ~ as.numeric(NA)
    ),
    AGEGR9 = case_when(
      AGEGR9N == 1 ~ "<18",
      AGEGR9N == 2 ~ "18 - 50",
      AGEGR9N == 3 ~ ">50",
      TRUE         ~ as.character(NA)
    )
  )

# ---------------------------------------------------------------------
# Step D: Complex Datetime Imputation for Treatment Start (TRTSDTM/F)
# ---------------------------------------------------------------------
# Pre-processing Exposure (EX) using the modern derive_vars_dtm() framework.
# Imputing missing hours/minutes to '00:00' per Roche specifications.

ex_processed <- ex %>%
  filter(EXDOSE > 0 | (EXDOSE == 0 & str_detect(toupper(EXTRT), "PLACEBO"))) %>%
  filter(!is.na(EXSTDTC) & EXSTDTC != "") %>%
  # Canonical format for date/time conversion and imputation
  derive_vars_dtm(
    dtc = EXSTDTC,
    new_vars_prefix = "TRTS",
    highest_imputation = "h",
    date_imputation = "first",
    time_imputation = "first"
  )

# Merging the imputed treatment start date into ADSL core via derive_vars_merged
adsl_trt <- adsl_age %>%
  derive_vars_merged(
    dataset_add = ex_processed,
    by_vars = exprs(STUDYID, USUBJID),
    order = exprs(TRTSDTM),
    mode = "first",
    new_vars = exprs(TRTSDTM, TRTSTMF)
  )

# ---------------------------------------------------------------------
# Step E: Consolidated Last Known Alive Date Calculation (LSTAVLDT)
# ---------------------------------------------------------------------
# Standard tidyverse extraction of chronological timeline metrics across domains

valid_vs <- vs %>%
  filter(!is.na(VSSTRESN) | !is.na(VSSTRESC)) %>%
  filter(!is.na(VSDTC) & VSDTC != "") %>%
  mutate(LST_DATE = date(ymd_hms(convert_dtc_to_dtm(VSDTC), quiet = TRUE))) %>%
  select(STUDYID, USUBJID, LST_DATE)

valid_ae <- ae %>%
  filter(!is.na(AESTDTC) & AESTDTC != "") %>%
  mutate(LST_DATE = date(ymd_hms(convert_dtc_to_dtm(AESTDTC), quiet = TRUE))) %>%
  select(STUDYID, USUBJID, LST_DATE)

valid_ds <- ds %>%
  filter(!is.na(DSSTDTC) & DSSTDTC != "") %>%
  mutate(LST_DATE = date(ymd_hms(convert_dtc_to_dtm(DSSTDTC), quiet = TRUE))) %>%
  select(STUDYID, USUBJID, LST_DATE)

valid_ex_dates <- ex_processed %>%
  mutate(LST_DATE = date(TRTSDTM)) %>%
  select(STUDYID, USUBJID, LST_DATE)

# Aggregating historical source datelines to calculate the terminal alive date
alive_stack <- bind_rows(valid_vs, valid_ae, valid_ds, valid_ex_dates) %>%
  filter(!is.na(LST_DATE)) %>%
  group_by(STUDYID, USUBJID) %>%
  summarise(LSTAVLDT = max(LST_DATE, na.rm = TRUE), .groups = "drop")

# Merging the final survival vector into the primary shape
adsl_final <- adsl_trt %>%
  left_join(alive_stack, by = c("STUDYID", "USUBJID"))

# ---------------------------------------------------------------------
# Step F: Pre-Submission Automated Integrity Testing
# ---------------------------------------------------------------------
test_that("ADaM ADSL Technical Compliance Assertions", {
  expect_true("AGEGR9"   %in% colnames(adsl_final))
  expect_true("AGEGR9N"  %in% colnames(adsl_final))
  expect_true("TRTSDTM"  %in% colnames(adsl_final))
  expect_true("ITTFL"    %in% colnames(adsl_final))
  expect_true("LSTAVLDT" %in% colnames(adsl_final))
})

print("=== ADaM ADSL Dataset Compiled Successfully (2026 Core Engine) ===")
print(adsl_final %>% select(USUBJID, AGE, AGEGR9, ITTFL, TRTSDTM, LSTAVLDT) %>% head(n = 5))

# Automated Directory Verification Guardrail
if (!dir.exists("question_2_adam")) {
  dir.create("question_2_adam", recursive = TRUE)
}

# Exporting final ADaM dataset package
write.csv(adsl_final, "question_2_adam/adam_adsl_dataset.csv", row.names = FALSE)
print("=== ADaM ADSL CSV Saved Successfully! ===")
