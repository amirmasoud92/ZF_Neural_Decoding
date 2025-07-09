######################################
# Figure S8 - Event  - Decoding performance of temporal features for each song using both LFP and MUAe.
######################################

# Load necessary libraries
library(lme4)
library(officer)

# Define significance threshold
significance_level <- 0.05

# Section 1: Define paths and load data
load_path <- '...'
save_path <- '...'

# Set working directory and load data
setwd(load_path)
file_in <- 'FigS8_Event.csv'
save_name <- 'Event_Fusion.csv'

df_event <- read.csv(file_in)

# Data Preprocessing
# Convert relevant columns to factors
df_event <- transform(df_event, 
                      Birds_Name = factor(Bird_Name),
                      Sex_Birds = factor(Sex),
                      Depth = factor(Depths))

# Summarize the data
summary(df_event)

# Initialize Word document
doc <- read_docx()
doc <- body_add_par(doc, paste0('File: ', gsub("\\.csv$", '', save_name)), style = "Normal")

# Function to fit models, perform ANOVA, and extract results
decode_analysis <- function(null_model_formula, effect_model_formula, data, label, save_path, save_name, doc) {
  # Fit null and effect models
  null_model <- lmer(null_model_formula, data = data, REML = FALSE)
  effect_model <- lmer(effect_model_formula, data = data, REML = FALSE)
  
  # Perform ANOVA to compare models
  anova_result <- anova(null_model, effect_model)
  write.csv(anova_result, file = paste0(save_path, 'Stat_', save_name, '_', label, '_anova_result.csv'))
  
  # Extract and format ANOVA and effect size results
  chi_square <- anova_result[2, "Chisq"]
  df <- anova_result[2, "Df"]
  p_value <- anova_result[2, "Pr(>Chisq)"]
  delta_r <- fixef(effect_model)["(Intercept)"]
  se <- sqrt(vcov(effect_model)["(Intercept)", "(Intercept)"])
  
  formatted_result <- sprintf('χ^2 (%d) = %.2f, p = %.8f; Δr = %.2f ± %.3f SE', 
                              df, chi_square, p_value, delta_r, se)
  doc <- body_add_par(doc, paste0("**", label, ": ", formatted_result, "**"), style = "Normal")
  
  return(doc)
}

# Model Fitting and Analysis for LFP Performance
doc <- decode_analysis(
  null_model_formula = (MeanFusion_Acc - MeanLFP_Acc) ~ -1 + (1 | Birds_Name),
  effect_model_formula = (MeanFusion_Acc - MeanLFP_Acc) ~ 1 + (1 | Birds_Name),
  data = df_event,
  label = "LFP Event",
  save_path = save_path,
  save_name = save_name,
  doc = doc
)

# Model Fitting and Analysis for MUAe Performance
doc <- decode_analysis(
  null_model_formula = (MeanFusion_Acc - MeanMUAe_Acc) ~ -1 + (1 | Birds_Name),
  effect_model_formula = (MeanFusion_Acc - MeanMUAe_Acc) ~ 1 + (1 | Birds_Name),
  data = df_event,
  label = "MUAe Event Detection",
  save_path = save_path,
  save_name = save_name,
  doc = doc
)

# Save Results in Word Format
print(doc, target = paste0(save_path, 'Stat_', save_name, '_results.docx'))
