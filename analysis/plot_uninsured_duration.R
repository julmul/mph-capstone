################################################
# Generate histogram of duration without insurance
# Author: Julia Muller
# Date: 18 February 2024
# Last modified: February 2024
################################################

# Load libraries
suppressPackageStartupMessages(library(tidyverse))

# Import data
data <- read_csv('data/no_insurance_filtered.csv', show_col_types = F)

# Plot duration of no insurance
plt <- ggplot(data = data) +
  geom_bar(aes(x = HILAST.f), stat = 'count', fill = 'black') +
  theme_minimal(base_size = 14) +
  theme(legend.position = 'none',
        axis.text.x = element_text(angle = 45, vjust = 1, hjust = 1)) +
  labs(x = 'Duration Without Insurance', y = 'Count (N)') +
  scale_y_continuous(breaks = seq(0, 700, by = 100))

# Export as PNG
ggsave('figures/duration_no_insurance.png', plt, height = 6, width = 8)
