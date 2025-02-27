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

# Factor variables in the order they should appear in the table
data <- data %>% 
  mutate(
    # HILAST.f = factor(HILAST.f, levels = c(
    #   '<1 year', '1 to <2 years', '2 to <3 years', '3 to <5 years', 
    #   '5 to <10 years', '10+ years', 'Never', 'Unknown')
    # ),
    HILAST.f = factor(HILAST.f, levels = c(
      '<1 year', '1 to <3 years', '3 to <5 years',
      '5 to <10 years', '10+ years', 'Never', 'Unknown')
    ),
    RACETH.f = factor(RACETH.f, levels = c(
      'White/non-Hispanic', 'White/Hispanic', 'Black', 'Other', 'Unknown')
    ),
    URBRRL.f = factor(URBRRL.f, levels = c(
      'Large central metro', 'Large fringe metro', 'Small/medium metro', 'Nonmetropolitan')
    ),
    EDUC.f = factor(EDUC.f, levels = c(
      'Grade 11 or less', 'High school diploma or GED', 'Some college',
      'Associate\'s degree', 'Bachelor\'s degree', 'Postgraduate degree', 'Unknown')
    ),
    CITIZEN.f = factor(CITIZEN.f, levels = c(
      'Yes', 'No', 'Unknown')
    )
  )

# Label variable names
label(data$AGE) <- 'Age'
label(data$SEX.f) <- 'Sex'
label(data$RACETH.f) <- 'Self-Reported Race/Ethnicity'
label(data$URBRRL.f) <- 'Urban Classification'
label(data$EDUC.f) <- 'Educational Attainment'
label(data$CITIZEN.f) <- 'Citizenship Status'

# Generate table 1
table <- table1(~ AGE + SEX.f + RACETH.f + URBRRL.f + EDUC.f + CITIZEN.f | HILAST.f,
                data = data,
                overall = c(left = 'Overall'))

# Convert to flextable for output
ft <- t1flex(table)
suppressMessages(save_as_image(ft, 'figures/table_1.png'))
