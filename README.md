# Advanced Clinical Data Science & RWE Analytics Suite

**Author:** Alex Mychlo, PhD  
**Domain:** Clinical Programming, Advanced RWE Analytics & GenAI Architectures  
**Core Stack:** R (Pharmaverse: sdtm.oak, admiral, gtsummary), Python (LangChain, Pandas)

This production-grade repository contains an end-to-end analytics framework demonstrating regulatory-compliant data engineering, statistical reporting, and Generative AI applications within the biopharmaceutical space. The suite is structured strictly in accordance with CDISC standards, modern open-source initiatives, and clinical data science best practices.

---

## 📂 Repository Architecture & Execution Traceability

The project is organized into modular directory structures ensuring clean code isolation and complete execution traceability with mandatory log evidence:

```text
clinical_analytics_suite/
├── README.md                          # Comprehensive project documentation suite
│
├── question_1_sdtm/
│   ├── 01_create_ds_domain.R        # SDTM Disposition (DS) domain mapping engine via {sdtm.oak}
│   ├── sdtm_ds_dataset.csv          # Final validated ISO-compliant SDTM dataset output
│   └── question_1_execution.log     # Execution log proving error-free SDTM compilation & unit tests
│
├── question_2_adam/
│   ├── create_adsl.R                # Subject-Level Analysis Dataset (ADSL) via {admiral} (Core Engine)
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

---

## 🛠️ Core Methodologies & Program-Level Deep Dive

### 1. SDTM Ingestion Engine via `{sdtm.oak}` (`question_1_sdtm/`)
* **`01_create_ds_domain.R`**: Configures a robust, zero-bug pipeline to map raw operational data into the CDISC SDTM Disposition (DS) domain.
  * **Dynamic Column Resolution**: Implements safe pattern-matching via regular expressions to dynamically detect and ingest target database strings (e.g., `DSTERM`, `DSDTC`), avoiding brittle hardcoding.
  * **Controlled Terminology Synchronization**: Aligns raw collected values directly against the mandatory **CDISC SDTM v3.4 Study Controlled Terminology** schema, mapping preferred terms via an integrated look-up matrix.
  * **ISO 8601 Temporal Standardization**: Deploys the `{sdtm.oak}` parsing engine to enforce uniform date-time compliance, complete with downstream validation metrics and automated `{testthat}` structural integrity assertions.

### 2. ADaM Architecture via `{admiral}` (`question_2_adam/`)
* **`create_adsl.R`**: Generates a regulatory-ready Subject-Level Analysis Dataset (ADSL) utilizing modern industry standards, completely replacing legacy deprecated methods.
  * **Complex Datetime Imputation**: Leverages stable `derive_vars_dtm()` and `derive_vars_merged()` pipelines to execute precise imputation for treatment exposure start times down to the seconds barrier.
  * **Consolidated Survival Metrics**: Implements multi-source data aggregation across disparate domains (`VS`, `AE`, `DS`, `EX`) to calculate a unified, deterministic terminal alive date (`LSTAVLDT`).
  * **Demographic Partitioning**: Programmatically derives Intent-to-Treat flags (`ITTFL`) and structured age-group classification factors (`AGEGR9`/`AGEGR9N`) backed by defensive testing guardrails.

### 3. Regulatory Reporting & Visualization Suite (`question_3_tlg/`)
* **`01_create_ae_summary_table.R`**: Replicates strict FDA Table 10 criteria for Treatment-Emergent Adverse Events (`TRTEMFL == "Y"`). It utilizes the `{gtsummary}` infrastructure to generate a hierarchical, multi-level summary table sorted by descending event frequency and styled as a publication-grade HTML asset.
* **`02_create_visualizations.R`**: Compiles an advanced statistical visualization matrix using `{ggplot2}`.
  * **Plot 1 (Severity Matrix)**: Renders a clean, stacked categorical distribution of AE intensities across active treatment arms.
  * **Plot 2 (Incidence Profile)**: Extracts the top 10 most frequent Adverse Events and computes exact **95% Clopper-Pearson Confidence Intervals** utilizing programmatic binomial tests, establishing verified risk margins.

### 4. GenAI Clinical Intelligence Suite (`question_4_python/`)
* **`clinical_agent.py` & `test_agent_queries.py`**: A native Python framework deploying an intelligent data agent powered by LangChain.
  * **Natural Language Routing**: Translates unstructured clinical queries (e.g., *"Identify all patients who experienced a Headache condition"*) into precise programmatic data filters.
  * **Structured Schema Mapping**: Bypasses fragile conditional loops by utilizing a strict semantic metadata dictionary layer, extracting metrics like unique subject counts and matching IDs on the fly.

---
*All analytical pipelines execute successfully with zero warnings and zero errors, verified via automated terminal log captures and comprehensive regression test suites.*
