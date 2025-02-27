################################################
# Generate table 2 of reasons and duration for no insurance
# Author: Julia Muller
# Date: 13 February 2024
# Last modified: February 2024
################################################

# Load libraries
suppressPackageStartupMessages({
  library(tidyverse)
  library(table1)
})

# Import data
data <- read_csv('data/no_insurance_filtered.csv', show_col_types = F)

# Filter out unknowns and factor yes/no responses in desired order
data <- data %>%
  mutate(
    across(c(
      HINOUNEMPR.f, HINOCOSTR.f, HINOWANT.f, HINOCONF.f, 
      HINOMEET.f, HINOWAIT.f, HINOMISS.f, HINOELIG.f),
      ~ factor(., levels = c('Yes', 'No', 'Unknown')))
    )

# Label reasons for no insurance variables
label(data$HINOUNEMPR.f) <- 'Unemployment'
label(data$HINOCOSTR.f) <- 'Too expensive'
label(data$HINOWANT.f) <- 'Does not want/need coverage'
label(data$HINOCONF.f) <- 'Too difficult/confusing'
label(data$HINOMEET.f) <- 'Does not meet needs'
label(data$HINOWAIT.f) <- 'Coverage has not started yet'
label(data$HINOMISS.f) <- 'Missed deadline to sign up'
label(data$HINOELIG.f) <- 'Not eligible'

# Generate table 2
table <- table1(~ HINOUNEMPR.f + HINOCOSTR.f + HINOWANT.f + HINOCONF.f +
                  HINOMEET.f + HINOWAIT.f + HINOMISS.f + HINOELIG.f | HILAST.f,
                data = data,
                overall = c(left = 'Overall'))

# Export as RDS
write_rds(table, 'figures/table_2.rds')
