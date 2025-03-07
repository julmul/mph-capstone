.PHONY: clean

clean:
	rm figures/*
	rm reports/report.pdf

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
	@echo 'Generating table 1 of demographics'
	@echo ''
	
# Generate table 2
figures/table_2.png:\
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

# Generate line graph of frequency of duration of no insurance by reason
figures/duration_no_insurance_by_reason.png:\
 data/no_insurance_filtered.csv\
 analysis/plot_uninsured_duration_by_reason.R
	Rscript analysis/plot_uninsured_duration_by_reason.R
	@echo 'Generating line graph of duration without insurance by reason'
	@echo ''

# Compile PDF
reports/report.pdf: reports/report.tex\
 figures/table_1.png\
 figures/table_2.png\
 figures/reason_no_insurance.png\
 figures/duration_no_insurance.png\
 figures/duration_no_insurance_by_reason.png
	pdflatex -output-directory=reports reports/report.tex > /dev/null 2>&1
	biber reports/report > /dev/null 2>&1
	pdflatex -output-directory=reports reports/report.tex > /dev/null 2>&1
	pdflatex -output-directory=reports reports/report.tex > /dev/null 2>&1
	rm reports/report.aux reports/report.log reports/report.out reports/report.toc reports/report.bbl reports/report.blg reports/report.bcf reports/report.run.xml
	@echo 'Building final report of analyses'
	@echo ''
