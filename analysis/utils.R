# Factor yes/no/unknown answers to all reasons for uninsurance
factor_reasons <- function(data) {
  data %>%
    mutate(
      across(c(
        HINOUNEMPR.f, HINOCOSTR.f, HINOWANT.f, HINOCONF.f, 
        HINOMEET.f, HINOWAIT.f, HINOMISS.f, HINOELIG.f),
        ~ factor(., levels = c('Yes', 'No', 'Unknown')))
      )
}

# Factor durations without insurance in proper chronological order
factor_hilast <- function(data) {
  data %>%
    mutate(HILAST.f = factor(HILAST.f, levels = c(
      '<1 year', '1 to <3 years', '3 to <5 years', '5 to <10 years', '10+ years', 'Never')))
}