factor_reasons <- function(data) {
  data %>%
    mutate(
      across(c(
        HINOUNEMPR.f, HINOCOSTR.f, HINOWANT.f, HINOCONF.f, 
        HINOMEET.f, HINOWAIT.f, HINOMISS.f, HINOELIG.f),
        ~ factor(., levels = c('Yes', 'No', 'Unknown')))
      )
}

factor_hilast <- function(data) {
  data %>%
    mutate(HILAST.f = factor(HILAST.f, levels = c(
      '<1 year', '1 to <3 years', '3 to <5 years', '5 to <10 years', '10+ years', 'Never')))
}

calculate_pvalue <- function(x, ...) {
  
  # Construct vectors of data y, and groups (strata) g
  y = unlist(x)
  g = factor(rep(1:length(x), times = sapply(x, length)))
  
  # Determine the number of levels in y
  num_levels = nlevels(factor(y))
  
  # Chi-squared test for entire stratum if levels are fewer than 4
  if (num_levels < 4) {
    p = chisq.test(table(y, g))$p.value
    p_formatted = format.pval(p, digits = 2, eps = 0.001) # Formatting
    if (p < 0.05) {
      p_formatted = paste0('<b>', p_formatted, '</b>') # Bold significant p-values
    }
    return(list('', p_formatted))
  } 
  
  # Perform chi-squared test or Fisher's Exact test for each level of y across strata
  else {
    p_values = character(num_levels) # List to store p-values
    levels_y = levels(factor(y)) # Levels of y
    
    # Insert an empty row before printing p-values
    p_values[1] = ''
    
    for (i in 1:num_levels) {
      level = levels_y[i]
      
      # Create binary variable for current level
      current_level = y == level
      
      # Create contingency table for current level vs all others
      contingency_table = table(current_level, g)
      
      # Perform chi-square test or Fisher's Exact test based on expected frequencies
      if (any(chisq.test(contingency_table)$expected < 5)) {
        p_value = fisher.test(contingency_table)$p.value
      } else {
        p_value = chisq.test(contingency_table)$p.value
      }
      
      # Format the p-value
      if (is.na(p_value)) {
        p_formatted = 'NA'
      } else {
        p_formatted = format.pval(p_value, digits = 2, eps = 0.001)
        if (p_value < 0.05) {
          p_formatted = paste0('<b>', p_formatted, '</b>') # Bold significant p-values
        }
      }
      p_values[i + 1] = p_formatted
    }
    return(p_values)
  }
}
