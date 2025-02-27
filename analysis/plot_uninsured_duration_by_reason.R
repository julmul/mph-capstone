################################################
# Generate line graph of duration without insurance by reason
# Author: Julia Muller
# Date: 27 February 2024
# Last modified: February 2024
################################################

# Load libraries
suppressPackageStartupMessages(library(tidyverse))

# Import data
data <- read_csv('data/no_insurance_filtered.csv', show_col_types = F)

# Calculate frequencies of reasons for no insurance by duration, then pivot longer
data_sum <- data %>%
  group_by(HILAST.f) %>%
  summarize(
    HINOUNEMPR.f = sum(HINOUNEMPR.f == 'Yes')/n(),
    HINOCOSTR.f = sum(HINOCOSTR.f == 'Yes')/n(),
    HINOTHER.f = sum(HINOTHER.f == 'Yes')/n(),
    HINOWANT.f = sum(HINOWANT.f == 'Yes')/n(),
    HINOCONF.f = sum(HINOCONF.f == 'Yes')/n(),
    HINOMEET.f = sum(HINOMEET.f == 'Yes')/n(),
    HINOWAIT.f = sum(HINOWAIT.f == 'Yes')/n(),
    HINOMISS.f = sum(HINOMISS.f == 'Yes')/n(),
    HINOELIG.f = sum(HINOELIG.f == 'Yes')/n()) %>%
  pivot_longer(
    cols = c('HINOUNEMPR.f', 'HINOCOSTR.f', 'HINOCONF.f', 'HINOWANT.f', 'HINOWANT.f', 'HINOTHER.f', 'HINOMEET.f', 'HINOWAIT.f', 'HINOMISS.f', 'HINOELIG.f'),
    names_to = 'reason',
    values_to = 'value') %>%
  ungroup()

# Factor duration without insurance for correct ordering
data_sum <- data_sum %>%
  # mutate(HILAST.f = factor(HILAST.f, levels = c(
  #   '<1 year', '1 to <2 years', '2 to <3 years', '3 to <5 years', '5 to <10 years', '10+ years', 'Never')))
  mutate(HILAST.f = factor(HILAST.f, levels = c(
    '<1 year', '1 to <3 years', '3 to <5 years', '5 to <10 years', '10+ years', 'Never')))
  
# Generate line graph of duration without insurance by reason
plt <- ggplot(data = data_sum) +
  geom_line(aes(x = HILAST.f, y = value, group = reason, color = reason), linewidth = 1) +
  theme_minimal(base_size = 18) +
  labs(x = 'Duration without Insurance', y = 'Frequency (%)') +
  scale_color_manual(
    name = NULL,
    labels = c('Too difficult/confusing', 'Too expensive', 'Not eligible', 'Does not meet needs', 'Missed deadline to sign up', 'Other', 'Unemployment', 'Coverage has not started yet', 'Does not want/need coverage'), 
    values = c('#E69F00', '#D55E00', '#56B4E9', '#0072B2', '#009E73', '#F0E442', '#CC79A7', '#000000', 'grey50')) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  guides(colour = guide_legend(override.aes = list(linewidth = 2.5)))

# Export as PNG
ggsave('figures/duration_no_insurance_by_reason.png', plt, height = 6, width = 12, dpi = 600)
