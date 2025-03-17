################################################
# Generate histogram of duration without insurance
# Author: Julia Muller
# Date: 18 February 2025
# Last modified: March 2025
################################################

# Load libraries
suppressPackageStartupMessages(library(tidyverse))

# Import data
data <- read_csv('data/no_insurance_filtered.csv', show_col_types = F)

# Source functions
source('analysis/utils.R')


#---------------#
# Functions ----
#---------------#
# Calculate proportions of duration without insurance, with optional stratification
calculate_proportions <- function(data, strat_var = NULL) {
  
  # Filter out unknowns from the stratifying variable 
  if (!is.null(strat_var)) {
    data <- data %>% filter(.data[[strat_var]] != 'Unknown')
  }
  
  # Calculate proportions of duration without insurance
  data %>%
    group_by(HILAST.f, !!!rlang::syms(strat_var)) %>%
    summarize(n = n(), .groups = 'drop') %>%
    group_by(!!!rlang::syms(strat_var)) %>%
    mutate(prop = n/sum(n), .groups = 'drop')
}

# Generate histogram of duration without insurance
plot_duration <- function(data, base_size) {
  
  # Factor duration variable
  data <- factor_hilast(data)
  
  # Generate histogram
  ggplot(data = data) +
    geom_bar(aes(x = HILAST.f, y = prop), stat = 'identity', fill = 'black') +
    theme_minimal(base_size = base_size) +
    theme(legend.position = 'none',
          axis.text.x = element_text(angle = 45, vjust = 1, hjust = 1)) +
    labs(x = 'Duration without Insurance', y = 'Proportion')
}


#--------------------------#
# Overall study sample ----
#--------------------------#
# Calculate proportions for overall study sample
data_sum <- calculate_proportions(data)

# Generate plot
plt <- plot_duration(data = data_sum, base_size = 16)
  

#-----------------------------#
# Stratify by citizenship ----
#-----------------------------#
# Calculate proportions by citizenship status
data_citizen <- calculate_proportions(data, 'CITIZEN.f')

# Add in sample sizes
data_citizen <- data_citizen %>%
  mutate(CITIZEN.f = factor(CITIZEN.f, 
                            levels = c('Citizen', 'Non-Citizen'), 
                            labels = c('Citizen (n=1168)', 'Non-Citizen (n=528)')))

# Plot duration of no insurance, facet wrapped by citizenship status
citizen_plt <- plot_duration(data = data_citizen, base_size = 18) +
  facet_wrap(~CITIZEN.f)


#--------------------------------#
# Stratify by race/ethnicity ----
#--------------------------------#
# Calculate proportions by race/ethnicity
data_race <- calculate_proportions(data, 'RACETH.f')

# Add in sample sizes
data_race <- data_race %>%
  mutate(RACETH.f = factor(RACETH.f, 
                           levels = c('White/non-Hispanic', 'White/Hispanic', 'Black', 'Other'),
                           labels = c('White/non-Hispanic (n=745)', 'White/Hispanic (n=414)', 'Black (n=199)', 'Other (n=138)')))

# Plot duration of no insurance, facet wrapped by race/ethnicity
race_plt <- plot_duration(data = data_race, base_size = 24) +
  facet_wrap(~RACETH.f)


#------------#
# Export ----
#------------#
ggsave('figures/duration_no_insurance.png', plt, height = 6, width = 8)
ggsave('figures/duration_no_insurance_by_citizen.png', citizen_plt, height = 6, width = 12)
ggsave('figures/duration_no_insurance_by_race.png', race_plt, height = 12, width = 18)
