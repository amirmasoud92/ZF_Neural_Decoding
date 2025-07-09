######################################
# Figure S8 - Envelope  - Decoding performance of temporal features for each song using both LFP and MUAe.
######################################

# Load necessary libraries
library(lme4)
library(officer)

# Define significance threshold
significance_level <- 0.05

# Define paths and load data
load_path <- '...'
save_path <- '...'

# Set working directory and load data
setwd(load_path)
file_in <- 'FigS8_Envelope.csv'
save_name <- 'Envelope_Fusion.csv'

df_Envelope <- read.csv(file_in)

# Data Preprocessing
# Convert relevant columns to factors
df_Envelope <- transform(df_Envelope, 
                         Birds_Name = factor(Bird_Name),
                         Sex_Birds = factor(Sex),
                         Depth = factor(Depths))

# Summarize the data
summary(df_Envelope)

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
  null_model_formula = (MeanFusion_Corr - MeanLFP_Corr) ~ -1 + (1 | Birds_Name),
  effect_model_formula = (MeanFusion_Corr - MeanLFP_Corr) ~ 1 + (1 | Birds_Name),
  data = df_Envelope,
  label = "LFP Envelope",
  save_path = save_path,
  save_name = save_name,
  doc = doc
)

# Model Fitting and Analysis for MUAe Performance
doc <- decode_analysis(
  null_model_formula = (MeanFusion_Corr - MeanMUAe_Corr) ~ -1 + (1 | Birds_Name),
  effect_model_formula = (MeanFusion_Corr - MeanMUAe_Corr) ~ 1 + (1 | Birds_Name),
  data = df_Envelope,
  label = "MUAe Envelope Detection",
  save_path = save_path,
  save_name = save_name,
  doc = doc
)

# Save Results in Word Format
print(doc, target = paste0(save_path, 'Stat_', save_name, '_results.docx'))
