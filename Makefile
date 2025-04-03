.PHONY: clean

clean:
	rm figures/*
	rm reports/report.pdf
	rm data/logistic_regression_output.rds

# Run entire analysis
all: reports/report.pdf

# Format variables according to codebook (only if raw data is available)
data/no_insurance_filtered.csv:\
 analysis/recode_variables.R
	if [ -f data/nhis_00006.csv.gz ]; then \
		Rscript analysis/recode_variables.R; \
	else \
		@echo 'Raw NHIS data (nhis_00006.csv.gz) not found. Skipping data processing.'; \
	fi
	@echo 'Filtering on inclusion criteria and recoding appropriately'
	@echo ''

# Generate table 1
figures/table_1.png:\
 data/no_insurance_filtered.csv\
 analysis/gen_table_1.R
	Rscript analysis/gen_table_1.R
	@echo 'Generating table 1 of respondent demographics'
	@echo ''
	
# Generate histogram of duration without insurance
figures/duration_no_insurance.png:\
 data/no_insurance_filtered.csv\
 analysis/plot_uninsured_duration.R
	Rscript analysis/plot_uninsured_duration.R
	@echo 'Generating histogram of duration without insurance'
	@echo ''

# Generate line graph of frequency of duration of no insurance by reason
figures/duration_no_insurance_by_reason.png:\
 data/no_insurance_filtered.csv\
 analysis/plot_uninsured_duration_by_reason.R
	Rscript analysis/plot_uninsured_duration_by_reason.R
	@echo 'Generating line graph of duration without insurance by reason'
	@echo ''

# Perform multivariate logistic regression for uninsured duration
data/logistic_regression_output.rds:\
 data/no_insurance_filtered.csv\
 analysis/fit_glm.R
	Rscript analysis/fit_glm.R
	@echo 'Running multivariate logistic regression'
	@echo ''
	
# Generate forest plot of regression output
figures/forestplot_uninsured_1_year.png:\
 data/logistic_regression_output.rds\
 analysis/gen_forestplot.R
	Rscript analysis/gen_forestplot.R
	@echo 'Generating forest plot of regression output'
	@echo ''

# Compile PDF
reports/report.pdf: reports/report.tex\
 figures/table_1.png\
 figures/duration_no_insurance.png\
 figures/duration_no_insurance_by_reason.png\
 figures/forestplot_uninsured_1_year.png
	pdflatex -output-directory=reports reports/report.tex > /dev/null 2>&1
	biber reports/report > /dev/null 2>&1
	pdflatex -output-directory=reports reports/report.tex > /dev/null 2>&1
	pdflatex -output-directory=reports reports/report.tex > /dev/null 2>&1
	rm reports/report.aux reports/report.log reports/report.out reports/report.toc reports/report.bbl reports/report.blg reports/report.bcf reports/report.run.xml
	@echo 'Building final report of analyses'
	@echo ''
