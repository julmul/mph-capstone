################################################
# Run multivariate logistic regression
# Author: Julia Muller
# Date: 27 March 2025
# Last modified: March 2025
################################################

# Load necessary package
suppressPackageStartupMessages({
  library(tidyverse)
})

# Import data
data <- read_csv('data/no_insurance_filtered.csv', show_col_types = F)


#----------------------#
# Data preparation ----
#----------------------#
# Create age categories
data <- data %>%
  mutate(AGE.f = case_when(
    AGE >= 18 & AGE <= 24 ~ 'Aged 18-24',
    AGE >= 25 & AGE <= 34 ~ 'Aged 25-34',
    AGE >= 35 & AGE <= 44 ~ 'Aged 35-44',
    AGE >= 45 & AGE <= 54 ~ 'Aged 45-54',
    AGE >= 55 & AGE <= 64 ~ 'Aged 55-64',
  ))

# Recode outcome variable as binary duration without insurance
data <- data %>%
  mutate(
    long_uninsured = if_else(HILAST.f == '<1 year', 0, 1),
    never_insured = if_else(HILAST.f == 'Never', 1, 0)
  )

# Select appropriate referents for categorical variables
data <- data %>%
  mutate(
    RACETH.f = relevel(factor(RACETH.f), ref = 'White/non-Hispanic'),
    EDUC.f = relevel(factor(EDUC.f), ref = 'High school diploma or GED'),
    POVERTY.f = relevel(factor(POVERTY.f), ref = '≥400% FPL')
  )


#-----------------------------#
# Run logistic regression ----
#-----------------------------#
# Run logistic regression with all reason variables as separate predictors
model_1year <- glm(long_uninsured ~ HINOUNEMPR.f + HINOCOSTR.f + HINOTHER.f + 
                     HINOWANT.f + HINOCONF.f + HINOMEET.f + HINOWAIT.f + 
                     HINOMISS.f + HINOELIG.f + AGE.f + RACETH.f + POVERTY.f + EDUC.f + CITIZEN.f,
                   data = data, family = binomial)

# Get data frame of odds ratios and 95% CIs from model output
model_output <- exp(cbind(odds_ratio = coef(model_1year), confint(model_1year))) %>%
  as.data.frame() %>%
  rownames_to_column(var = 'variable') %>%
  rename(ci_lower = `2.5 %`, ci_upper = `97.5 %`) %>%
  filter(variable != '(Intercept)')


#-----------------------------#
# Clean regression output ----
#-----------------------------#
# Group output by type of variable
model_output <- model_output %>%
  filter(!grepl('\\.fUnknown$', variable)) %>%
  mutate(category = case_when(
    grepl('HINO', variable) ~ 'Reason for Uninsurance',
    grepl('AGE', variable) ~ 'Demographics',
    grepl('RACETH', variable) ~ 'Demographics',
    grepl('POVERTY', variable) ~ 'Socioeconomic Status',
    grepl('EDUC', variable) ~ 'Highest Level of Education',
    grepl('CITIZEN', variable) ~ 'Demographics',
    TRUE ~ 'Other'
  ))

# Update variable naming for readability
model_output <- model_output %>%
  mutate(variable = case_when(
    variable == 'HINOUNEMPR.fYes' ~ 'Unemployed',
    variable == 'HINOCOSTR.fYes' ~ 'Too expensive',
    variable == 'HINOTHER.fYes' ~ 'Other reason',
    variable == 'HINOWANT.fYes' ~ 'Do not want',
    variable == 'HINOCONF.fYes' ~ 'Too confusing',
    variable == 'HINOMEET.fYes' ~ 'Plans do not meet needs',
    variable == 'HINOWAIT.fYes' ~ 'Coverage not yet started',
    variable == 'HINOMISS.fYes' ~ 'Missed deadline',
    variable == 'HINOELIG.fYes' ~ 'Not eligible',
    variable == 'AGE.fAged 18-24' ~ 'Aged 18-24',
    variable == 'AGE.fAged 25-34' ~ 'Aged 25-34',
    variable == 'AGE.fAged 35-44' ~ 'Aged 35-44',
    variable == 'AGE.fAged 45-54' ~ 'Aged 45-54',
    variable == 'AGE.fAged 55-64' ~ 'Aged 55-64',
    variable == 'RACETH.fOther' ~ 'Other race',
    variable == 'RACETH.fWhite/Hispanic' ~ 'White/Hispanic',
    variable == 'RACETH.fBlack' ~ 'Black/African American',
    variable == 'POVERTY.f<100% FPL' ~ '<100% FPL',
    variable == 'POVERTY.f100 to <200% FPL' ~ '100 to <200% FPL',
    variable == 'POVERTY.f200 to <400% FPL' ~ '200 to <400% FPL',
    variable == 'EDUC.fBachelor\'s degree' ~ 'Bachelor\'s degree',
    variable == 'EDUC.fAssociate\'s degree' ~ 'Associate\'s degree',
    variable == 'EDUC.fGrade 11 or less' ~ 'No high school diploma',
    variable == 'EDUC.fHigh school diploma or GED' ~ 'High school/GED',
    variable == 'EDUC.fPostgraduate degree' ~ 'Postgraduate degree',
    variable == 'EDUC.fSome college' ~ 'Some college',
    variable == 'CITIZEN.fNon-Citizen' ~ 'Non-US citizen',
  ))

# Create new column indicating statistical significance
model_output <- model_output %>%
  mutate(significant = if_else(ci_lower > 1 | ci_upper < 1, 'Significant', 'Not Significant'))

# Export cleaned model output
write_rds(model_output, 'data/logistic_regression_output.rds')
