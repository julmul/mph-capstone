################################################
# Compute p-values using chi-squared tests
# Author: Julia Muller
# Date: 1 April 2025
# Last modified: April 2025
################################################

# Load libraries
suppressPackageStartupMessages({
  library(tidyverse)
})

# Import data
data <- read_csv('data/no_insurance_filtered.csv', show_col_types = F)

# Filter out unknowns from reasons for uninsurance
data <- data %>% filter(!if_any(starts_with('HINO'), ~ . == 'Unknown'))

# Chi-squared tests comparing duration and reason for uninsurance
chisq.test(table(data$HILAST.f, data$HINOUNEMPR.f))
chisq.test(table(data$HILAST.f, data$HINOCOSTR.f))
chisq.test(table(data$HILAST.f, data$HINOTHER.f))
chisq.test(table(data$HILAST.f, data$HINOWANT.f))
chisq.test(table(data$HILAST.f, data$HINOCONF.f))
chisq.test(table(data$HILAST.f, data$HINOMEET.f))
chisq.test(table(data$HILAST.f, data$HINOWAIT.f))
chisq.test(table(data$HILAST.f, data$HINOMISS.f))
chisq.test(table(data$HILAST.f, data$HINOWANT.f))