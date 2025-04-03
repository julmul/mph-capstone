################################################
# Generate forest plot of regression output
# Author: Julia Muller
# Date: 27 March 2025
# Last modified: March 2025
################################################

# Load libraries
suppressPackageStartupMessages({
  library(tidyverse)
})

# Import data
data <- read_rds('data/logistic_regression_output.rds')

# Arrange by category and factor to get desired output in forest plot
data <- data %>%
  arrange(category) %>%
  mutate(variable = factor(variable, levels = rev(unique(variable))))
  
# Generate forest plot
plt <- ggplot(data, aes(x = odds_ratio, y = variable, color = category, shape = significant)) +
  geom_point(size = 3) +
  geom_errorbarh(aes(xmin = ci_lower, xmax = ci_upper), height = 0.2) +
  geom_vline(xintercept = 1, linetype = 'dashed', color = 'grey50') +
  labs(x = 'Adjusted Odds Ratio and 95% CI', y = NULL, color = 'Covariates', shape = 'Statistical Significance') +
  scale_color_manual(values = c('Demographics' = '#0072B2',
                                'Highest Level of Education' = '#009E73', 
                                'Reason for Uninsurance' = '#D55E00',
                                'Socioeconomic Status' = '#F0E442')) +
  scale_shape_manual(values = c('Significant' = 16, 'Not Significant' = 1)) +
  theme_light(base_size = 14)

# Export PNG
ggsave('figures/forestplot_uninsured_1_year.png', plt, height = 7.5, width = 8.5)
