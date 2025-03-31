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
  library(flextable)
})

# Import data
data <- read_csv('data/no_insurance_filtered.csv', show_col_types = F)

# Source functions
source('analysis/utils.R')

# Filter out unknowns and factor yes/no responses in desired order
data <- data %>%
  factor_reasons() %>%
  factor_hilast()

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
                overall = c(left = 'Overall'),
                render.categorical = 'Freq (PCTnoNA%)',
                render.missing = 'Freq')

# Convert to flextable for output
ft <- t1flex(table)
save_as_image(ft, 'figures/table_2.png')
