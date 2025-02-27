################################################
# Filter and recode data according to study protocol
# Author: Julia Muller
# Date: 21 January 2024
# Last modified: February 2024
################################################

# Load libraries
suppressPackageStartupMessages(library(tidyverse))

# Import data
data <- read_csv('data/nhis_00006.csv.gz', show_col_types = F)

# Filter based on study inclusion criteria
data <- data %>%
  filter(
    HILAST != 0, 
    AGE < 65 & AGE > 17
  )

# Recode and format demographic variables
data <- data %>%
  mutate(
    SEX.f = case_when(
      SEX == 1 ~ 'Male',
      SEX == 2 ~ 'Female',
      SEX %in% 7:9 ~ 'Unknown'
    ),
    RACENEW.f = case_when(
      RACENEW == 100 ~ 'White',
      RACENEW == 200 ~ 'Black',
      RACENEW %in% c(300:600) ~ 'Other',
      RACENEW %in% 997:999 ~ 'Unknown'
    ),
    HISPETH.f = case_when(
      HISPETH == 10 ~ 'No',
      HISPETH %in% 90:99 ~ 'Unknown',
      TRUE ~ 'Yes'
    ),
    RACETH.f = case_when(
      RACENEW.f == 'White' & HISPETH.f == 'No' ~ 'White/non-Hispanic',
      RACENEW.f == 'White' & HISPETH.f == 'Yes' ~ 'White/Hispanic',
      RACENEW.f == 'Black' ~ 'Black',
      RACENEW.f == 'Other' ~ 'Other',
      RACENEW.f == 'Unknown' ~ 'Unknown'
    ),
    EDUC.f = case_when(
      EDUC == 000 ~ 'NIU',
      EDUC %in% 100:116 ~ 'Grade 11 or less',
      EDUC %in% 200:202 ~ 'High school diploma or GED',
      EDUC == 301 ~ 'Some college',
      EDUC %in% 300:303 ~ 'Associate\'s degree',
      EDUC == 400 ~ 'Bachelor\'s degree',
      EDUC %in% 500:505 ~ 'Postgraduate degree',
      EDUC %in% 996:999 ~ 'Unknown'
    ),
    CITIZEN.f = case_when(
      CITIZEN == 1 ~ 'No',
      CITIZEN == 2 ~ 'Yes',
      CITIZEN %in% 7:9 ~ 'Unknown'
    ),
    URBRRL.f = case_when(
      URBRRL == 1 ~ 'Large central metro',
      URBRRL == 2 ~ 'Large fringe metro',
      URBRRL == 3 ~ 'Small/medium metro',
      URBRRL == 4 ~ 'Nonmetropolitan'
    )
  )

# Recode and format duration without coverage variables
data <- data %>%
  mutate(
    HILAST.f = case_when(
      HILAST == 00 ~ 'NIU',
      HILAST == 14 ~ '<1 year',
      HILAST == 23 ~ '1 to <2 years',
      HILAST == 24 ~ '2 to <3 years',
      HILAST == 33 ~ '3 to <5 years',
      HILAST == 34 ~ '5 to <10 years',
      HILAST == 35 ~ '10+ years',
      HILAST == 40 ~ 'Never',
      HILAST %in% 97:99 ~ 'Unknown'
    )
  )

# Recode no insurance variables
data <- data %>%
  mutate(
    HINOUNEMPR.f = case_when(
      HINOUNEMPR == 0 ~ 'NIU',
      HINOUNEMPR == 1 ~ 'No',
      HINOUNEMPR == 2 ~ 'Yes',
      HINOUNEMPR %in% 7:9 ~ 'Unknown'
    ),
    HINOCOSTR.f = case_when(
      HINOCOSTR == 0 ~ 'NIU',
      HINOCOSTR == 1 ~ 'No',
      HINOCOSTR == 2 ~ 'Yes',
      HINOCOSTR == 9 ~ 'Unknown'
    ),
    HINOTHER.f = case_when(
      HINOTHER == 0 ~ 'NIU',
      HINOTHER == 1 ~ 'No',
      HINOTHER == 2 ~ 'Yes',
      HINOTHER %in% 7:9 ~ 'Unknown'
    ),
    HINOWANT.f = case_when(
      HINOWANT == 0 ~ 'NIU',
      HINOWANT == 1 ~ 'No',
      HINOWANT == 2 ~ 'Yes',
      HINOWANT %in% 7:9 ~ 'Unknown'
    ),
    HINOCONF.f = case_when(
      HINOCONF == 0 ~ 'NIU',
      HINOCONF == 1 ~ 'No',
      HINOCONF == 2 ~ 'Yes',
      HINOCONF %in% 7:9 ~ 'Unknown'
    ),
    HINOMEET.f = case_when(
      HINOMEET == 0 ~ 'NIU',
      HINOMEET == 1 ~ 'No',
      HINOMEET == 2 ~ 'Yes',
      HINOMEET %in% 7:9 ~ 'Unknown'
    ),
    HINOWAIT.f = case_when(
      HINOWAIT == 0 ~ 'NIU',
      HINOWAIT == 1 ~ 'No',
      HINOWAIT == 2 ~ 'Yes',
      HINOWAIT %in% 7:9 ~ 'Unknown'
    ),
    HINOMISS.f = case_when(
      HINOMISS == 0 ~ 'NIU',
      HINOMISS == 1 ~ 'No',
      HINOMISS == 2 ~ 'Yes',
      HINOMISS %in% 7:9 ~ 'Unknown'
    ),
    HINOELIG.f = case_when(
      HINOELIG == 0 ~ 'NIU',
      HINOELIG == 1 ~ 'No',
      HINOELIG == 2 ~ 'Yes',
      HINOELIG %in% 7:9 ~ 'Unknown'
    )
  )

# Export recoded data set
write_csv(data, 'data/no_insurance_filtered.csv')
