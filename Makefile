.PHONY: clean

# Remove processed data and figures
clean:
	rm data/processed/*
	rm figures/*
	rm report.html

# Run entire analysis
all: report.pdf

# Format variables according to codebook
data/no_insurance_filtered.csv:\
 data/nhis_00006.csv.gz\
 analysis/recode_variables.R
	Rscript analysis/recode_variables.R
	@echo 'Filtering on inclusion criteria and recoding appropriately'
	@echo ''

# Generate table 1
figures/table_1.rds:\
 data/no_insurance_filtered.csv\
 analysis/gen_table_1.R
	Rscript analysis/gen_table_1.R
	@echo 'Generating table 1 of demographics'
	@echo ''
	
# Generate table 2
figures/table_2.rds:\
 data/no_insurance_filtered.csv\
 analysis/gen_table_2.R
	Rscript analysis/gen_table_2.R
	@echo 'Generating table 2 of reasons for no insurance vs. duration without insurance'
	@echo ''
	
# Generate histogram of reasons for no insurance
figures/reason_no_insurance.png:\
 data/no_insurance_filtered.csv\
 analysis/plot_uninsured_reasons.R
	Rscript analysis/plot_uninsured_reasons.R
	@echo 'Generating histogram of reasons for no insurance'
	@echo ''
	
# Generate histogram of duration without insurance
figures/duration_no_insurance.png:\
 data/no_insurance_filtered.csv\
 analysis/plot_uninsured_duration.R
	Rscript analysis/plot_uninsured_duration.R
	@echo 'Generating histogram of duration without insurance'
	@echo ''
	
# Build final report
report.pdf: report.Rmd\
 figures/table_1.rds\
 figures/table_2.rds\
 figures/reason_no_insurance.png\
 figures/duration_no_insurance.png
	Rscript -e "rmarkdown::render('report.Rmd', output_format = 'pdf_document', quiet = TRUE)"
	@echo 'Building final report of analyses'
	@echo ''

