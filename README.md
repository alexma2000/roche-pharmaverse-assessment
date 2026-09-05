# PD Data Sciences & Analytics (PDD) - Technical Assessment Suite
**Candidate:** Alex Mychlo, PhD  
**Role:** Analytical Data Science Programmer  
**Date:** September 2026  

This repository contains the complete production-grade solutions for the Roche PDD technical expertise evaluation, structured strictly in accordance with regulatory clinical programming and data science best practices.

## 📂 Repository Architecture & Contents

The project is organized into modular directory structures ensuring clean code isolation and complete execution traceability with mandatory log evidence:

```text
roche_test/
├── README.md                          # Comprehensive project documentation suite
│
├── question_1_sdtm/
│   ├── 01_create_ds_domain.R        # SDTM Disposition (DS) domain mapping engine via {sdtm.oak}
│   ├── sdtm_ds_dataset.csv          # Final validated ISO-compliant SDTM dataset output
│   └── question_1_execution.log     # Execution log proving error-free SDTM compilation & unit tests
│
├── question_2_adam/
│   ├── create_adsl.R                # Subject-Level Analysis Dataset (ADSL) via {admiral} (2026 Core)
│   ├── adam_adsl_dataset.csv        # Final CDISC-compliant ADaM dataset package
│   └── question_2_execution.log     # Execution log proving 100% compliance on ADSL derivations
│
├── question_3_tlg/
│   ├── 01_create_ae_summary_table.R # FDA Table 10: Treatment-Emergent AEs via {gtsummary}
│   ├── 02_create_visualizations.R   # Statistical distributions & Clopper-Pearson 95% CIs via {ggplot2}
│   ├── ae_summary_table.html        # Output publication-grade table file (FDA Table 10)
│   ├── ae_severity_distribution.png # Plot 1: Stacked severity distribution matrix
│   ├── top_10_frequent_aes.png      # Plot 2: Incidence rates error-bar profile with exact CIs
│   └── question_3_execution.log     # Execution log verifying seamless TLG rendering and storage
│
└── question_4_python/
    ├── clinical_agent.py            # GenAI Safety Data Agent built with LangChain JSON parsing logic
    ├── test_agent_queries.py        # Independent verification test script executing benchmark queries
    └── question_4_execution.log     # Terminal execution log verifying 3 benchmark NL safety queries
```

## 🛠️ Core Methodologies & Technical Pillars

### 1. SDTM Processing via `{sdtm.oak}`
- Implemented `sdtm.oak` mapping primitives combined with dynamic column pattern evaluation to ingest messy database strings.
- Synchronized raw target values against the mandatory **CDISC SDTM v3.4 Study Controlled Terminology** block.
- Enforced complete ISO 8601 string conversions for temporal anchors using deterministic parsing.

### 2. ADaM Architecture via `{admiral}`
- Engineered the `ADSL` data structure under the updated 2026 multi-modal engine using stable `derive_vars_dtm()` and `derive_vars_merged()` parameters, completely eliminating legacy deprecated methods.
- Executed strict datetime imputation for Treatment Start (`TRTSDTM`/`TRTSTMF`) down to the seconds barrier based on valid exposure rules.
- Consolidated multi-source operational datelines (`VS`, `AE`, `DS`, `EX`) to extract a unified terminal alive metric (`LSTAVLDT`).

### 3. Regulatory Reporting & Visualization Suite
- Replicated FDA Table 10 criteria isolating Treatment-Emergent AEs (`TRTEMFL == "Y"`) partitioned by System Organ Class hierarchies.
- Configured programmatic binomial tests to calculate exact **95% Clopper-Pearson Confidence Intervals** for incidence reporting in Plot 2.

### 4. GenAI Clinical Intelligence Suite
- Built a native `ClinicalTrialDataAgent` parsing entity on Python utilizing structured schema metadata.
- Engineered a modular intent routing pipeline (`Prompt ➔ Parse ➔ Execute`) capable of translating unstructured safety queries into executable internal dataframe filtering expressions without relying on fragile hardcoded conditional matrices.

---
*All pipelines have been successfully executed and validated via robust defensive assertions utilizing the `{testthat}` framework with 0 warnings and 0 errors.*
