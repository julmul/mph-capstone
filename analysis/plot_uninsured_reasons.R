################################################
# Generate histogram of reasons for no insurance
# Author: Julia Muller
# Date: 13 February 2024
# Last modified: February 2024
################################################

# Load libraries
suppressPackageStartupMessages(library(tidyverse))

# Import data
data <- read_csv('data/no_insurance_filtered.csv', show_col_types = F)

# Pivot data to long format for plotting
data_long <- data %>%
  select(matches('^HINO.*\\.f$')) %>%
  pivot_longer(
    cols = starts_with('HINO'),
    names_to = 'reason',
    values_to = 'response') %>%
  filter(response == 'Yes') %>%
  mutate(
    reason = factor(reason, 
    levels = c('HINOCOSTR.f', 'HINOWANT.f', 'HINOELIG.f', 'HINOCONF.f', 'HINOMEET.f', 'HINOWAIT.f', 'HINOTHER.f', 'HINOUNEMPR.f', 'HINOMISS.f'),
    labels = c('Too expensive', 'Do not want', 'Not eligible', 'Too confusing', 'Plans not meet needs', 'Coverage not started yet', 'Other', 'Unemployed', 'Missed deadline'))
  ) %>%
  filter(reason != 'NA')

# Plot counts of reasons for no insurance
plt <- ggplot(data = data_long) +
  geom_bar(aes(x = reason, fill = response), stat = 'count', fill = 'black') +
  theme_minimal(base_size = 14) +
  theme(legend.position = 'none',
        axis.text.x = element_text(angle = 45, vjust = 1, hjust = 1)) +
  labs(x = 'Reason for No Insurance', y = 'Count (N)') +
  scale_y_continuous(breaks = seq(0, 1400, by = 200))

# Export as PNG
ggsave('figures/reason_no_insurance.png', plt, height = 6, width = 8)
