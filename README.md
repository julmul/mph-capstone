# Understanding Gaps in Health Coverage: Reasons for and Duration of Uninsurance in the United States in 2023

This repository contains final capstone project for EPID 992 as part of my MPH in Applied Epidemiology at UNC Gillings School of Global Public Health.

This project explores the reasons why adults aged 18 to 64 in the U.S. remain without health insurance, with a focus on understanding how these reasons relate to the duration of being uninsured. Using data from the 2023 National Health Interview Survey (NHIS), this project analyzes demographic and socioeconomic factors that influence the likelihood of being uninsured and the reasons individuals cite for lacking health coverage. The findings aim to inform strategies for addressing barriers to insurance access.

## Repository Structure

* `analysis/` – Contains R scripts used for data cleaning, analysis, and visualization.

* `data/` – Contains processed datasets used in the project (raw NHIS data not included).

* `figures/` - Contains generated plots and visualizations used in the final report.

* `reports/` – Contains the final report and supplementary materials.

* `Makefile` – Automates the workflow for running scripts and generating outputs.

## Data

All data came from the 2023 U.S. National Health Interview Survey (NHIS), obtained from the IPUMS database. The original NHIS data are not included in this repository. The dataset used for analysis is a processed version of the NHIS data, which includes information on insurance status, demographic characteristics, and socioeconomic factors for adults aged 18 to 64.

**Citation:** Blewett, L., Rivera Drew, J., King, M., Williams, K., Backman, B., Chen, A., & Richards, S. (2024). *IPUMS Health Surveys: National Health Interview Survey (Version 7.4) [Dataset]*. IPUMS. https://doi.org/10.18128/D070.V7.4

## Final Report

The final capstone report is located in `reports/report.pdf`

## Reproducibility

These steps should be run in a Unix-based environment (e.g., macOS, Linux, or Windows with WSL). To reproduce the analysis:

1. Ensure prerequisites are installed (`R`, `make`, `biber`, and `pdflatex`).

2. Clone the repository: 

```
git clone https://github.com/julmul/mph-capstone.git
cd mph-capstone
```

3. Install necessary R packages:

```
Rscript -e "install.packages(c('tidyverse', 'table1', 'flextable'))"
```

4. Remove previously generated figures and datasets in a terminal:

```
make clean
```

5. Re-run the full analysis in a terminal:
  
```
make all
```

This will perform any necessary analyses, create figures, and compile the final report.
