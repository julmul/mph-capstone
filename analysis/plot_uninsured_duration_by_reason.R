################################################
# Generate line graphs of duration without insurance by reason
# Author: Julia Muller
# Date: 27 February 2025
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
# Calculate proportions of reasons for no insurance by duration/stratifying variable
calculate_proportions <- function(data, strat_var = NULL) {
  
  # Filter out unknowns from the stratifying variable
  if (!is.null(strat_var)) {
    data <- data %>% filter(.data[[strat_var]] != 'Unknown')
  }
  
  # Calculate proportions of reasons by duration and stratifying variable
  data %>%
    group_by(HILAST.f, !!!rlang::syms(strat_var)) %>%
    summarize(
      across(
        c(HINOUNEMPR.f, HINOCOSTR.f, HINOCONF.f, HINOWANT.f, 
          HINOTHER.f, HINOMEET.f, HINOWAIT.f, HINOMISS.f, HINOELIG.f),
        ~ sum(. == 'Yes', na.rm = T) / n(),
        .names = "{.col}")) %>%
    
    # Pivot longer for plotting
    pivot_longer(
      cols = c(HINOUNEMPR.f, HINOCOSTR.f, HINOCONF.f, HINOWANT.f, 
               HINOTHER.f, HINOMEET.f, HINOWAIT.f, HINOMISS.f, HINOELIG.f),
      names_to = 'reason',
      values_to = 'value') %>%
    ungroup()
}

# Generate line graph of duration without insurance by reason
plot_reasons_by_dur <- function(data, base_size = 20) {
  ggplot(data = data) +
    geom_line(aes(x = HILAST.f, y = value*100, group = reason, color = reason), linewidth = 1) +
    theme_minimal(base_size = 20) +
    labs(x = 'Duration Without Insurance', y = 'Answered Yes (%)') +
    scale_color_manual(
      name = 'Reasons for No Insurance',
      labels = c('Too difficult/confusing', 'Too expensive', 'Not eligible', 'Does not meet needs', 'Missed deadline to sign up', 'Other', 'Unemployment', 'Coverage has not started yet', 'Does not want/need coverage'), 
      values = c('#E69F00', '#D55E00', '#56B4E9', '#0072B2', '#009E73', '#F0E442', '#CC79A7', '#000000', 'grey50')) +
    theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
    guides(colour = guide_legend(override.aes = list(linewidth = 2.5)))
}


#--------------------------#
# Overall study sample ----
#--------------------------#
# Calculate proportions of reasons for no insurance by duration, no stratification
data_sum <- calculate_proportions(data)
data_sum <- factor_hilast(data_sum)

# Generate plot
plt <- plot_reasons_by_dur(data_sum)


#-----------------------------#
# Stratify by citizenship ----
#-----------------------------#
# Calculate proportions, stratified by citizenship status
data_citizen <- calculate_proportions(data, 'CITIZEN.f')

# Add in sample sizes
data_citizen <- data_citizen %>%
  mutate(CITIZEN.f = factor(CITIZEN.f, 
                            levels = c('Citizen', 'Non-Citizen'), 
                            labels = c('Citizen (n=1168)', 'Non-Citizen (n=528)')))

# Generate plot, facet wrapped by citizenship status
citizen_plt <- plot_reasons_by_dur(data_citizen) +
  facet_wrap(~CITIZEN.f)


#--------------------------------#
# Stratify by race/ethnicity ----
#--------------------------------#
# Calculate proportions, stratified by race/ethnicity
data_race <- calculate_proportions(data, 'RACETH.f')

# Add in sample sizes
data_race <- data_race %>%
  mutate(RACETH.f = factor(RACETH.f, 
                           levels = c('White/non-Hispanic', 'White/Hispanic', 'Black', 'Other'),
                           labels = c('White/non-Hispanic (n=745)', 'White/Hispanic (n=414)', 'Black (n=199)', 'Other (n=138)')))

# Generate plot and facet wrap by race
race_plt <- plot_reasons_by_dur(data_race, base_size = 24) +
  facet_wrap(~RACETH.f)


#---------------------#
# Stratify by FPL ----
#---------------------#
# Calculate proportions, stratified by FPL
data_fpl <- calculate_proportions(data, 'POVERTY.f')

# Add in sample sizes
data_fpl <- data_fpl %>%
  mutate(POVERTY.f = factor(POVERTY.f,
                           levels = c('<100% FPL', '100 to <200% FPL', '200 to <400% FPL', '≥400% FPL'),
                           labels = c('<100% FPL (n=363)', '100 to <200% FPL (n=556)', '200 to <400% FPL (n=584)', '≥400% FPL (n=301)')))

# Generate plot and facet wrap by race
fpl_plt <- plot_reasons_by_dur(data_fpl, base_size = 24) +
  facet_wrap(~POVERTY.f)


#------------#
# Export ----
#------------#
ggsave('figures/duration_no_insurance_by_reason.png', plt, height = 6, width = 12, dpi = 600)
ggsave('figures/duration_no_insurance_by_reason_by_citizen.png', citizen_plt, height = 6, width = 18, dpi = 600)
ggsave('figures/duration_no_insurance_by_reason_by_race.png', race_plt, height = 12, width = 18, dpi = 600)
ggsave('figures/duration_no_insurance_by_reason_by_fpl.png', fpl_plt, height = 12, width = 18, dpi = 600)
