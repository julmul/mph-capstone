################################################
# Generate table 1 of the study population
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

# Factor variables in the order they should appear in the table
data <- data %>%
  mutate(RACETH.f = if_else(is.na(RACETH.f), 'Unknown', RACETH.f)) %>%
  factor_hilast() %>%
  mutate(
    RACETH.f = factor(RACETH.f, levels = c(
      'White/non-Hispanic', 'White/Hispanic', 'Black', 'Other', 'Unknown')),
    URBRRL.f = factor(URBRRL.f, levels = c(
      'Large central metro', 'Large fringe metro', 'Small/medium metro', 'Nonmetropolitan')),
    EDUC.f = factor(EDUC.f, levels = c(
      'Grade 11 or less', 'High school diploma or GED', 'Some college',
      'Associate\'s degree', 'Bachelor\'s degree', 'Postgraduate degree', 'Unknown')),
    CITIZEN.f = factor(CITIZEN.f, levels = c(
      'Citizen', 'Non-Citizen', 'Unknown')),
    POVERTY.f = factor(POVERTY.f, levels = c(
      '<100% FPL', '100 to <150% FPL', '150 to <400% FPL', '≥400% FPL'))
  )

# Label variable names
label(data$AGE) <- 'Age'
label(data$SEX.f) <- 'Sex'
label(data$RACETH.f) <- 'Self-Reported Race/Ethnicity'
label(data$URBRRL.f) <- 'Urban Classification'
label(data$EDUC.f) <- 'Educational Attainment'
label(data$POVERTY.f) <- 'Household Federal Poverty Level'
label(data$CITIZEN.f) <- 'Citizenship Status'

# Generate table 1
tbl <- table1(~ AGE + SEX.f + RACETH.f + CITIZEN.f + EDUC.f + POVERTY.f | HILAST.f,
                data = data,
                overall = c(left = 'Overall'))

# Convert to flextable for output
ft <- t1flex(tbl)
save_as_image(ft, 'figures/table_1.png')
