# Investigating Reasons for Uninsurance in the 2023 NHIS Dataset

This repository contains my final capstone project for EPID 992 as part of my MPH in Applied Epidemiology at UNC Gillings School of Global Public Health.
The project analyzes the reasons for uninsurance in the 2023 National Health Interview Survey (NHIS) dataset and their correlation with duration without insurance. 
The analysis is stratified by demographic factors to identify disparities and inform policy solutions.

## Repository Structure

* `data/` – Processed datasets (raw NHIS data not included).

* `analysis/` – R scripts for data cleaning and visualization.

* `figures/` - Generated plots and visualizations used in the analysis and report.

* `reports/` – Final report summarizing key findings.

* `Makefile` – Automates the workflow for running scripts and generating outputs.

## Usage

1. Clone the repository: 

```
git clone https://github.com/julmul/MPH-capstone.git
cd capstone-project
```

2. Run the full analysis in a terminal using the Makefile:
  
```
make all
```

3. View the final report by navigating to reports/report.pdf.
