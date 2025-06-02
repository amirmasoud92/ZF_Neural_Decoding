# Envelope ---- Compare Performance LFP vs MUAe


# Load necessary libraries
library(tidyverse)
library(lme4)
library(officer)
library(emmeans)

# Set options to adjust limit for large datasets
emm_options(pbkrtest.limit = 7320, lmerTest.limit = 7320)

# Define significance threshold
significance_level <- 0.05

# Section 1: Define paths and load data
Load_Path <- 'C:/Amir/Phd research/Article Phd/Thesis/Ahmadi et al 1/Data Figures/New/'
Save_Path <- 'C:/Amir/Phd research/Article Phd/Thesis/Ahmadi et al 1/Statistical Analysis/Results/'

# Set working directory and load data
setwd(Load_Path)
fileIn <- 'Fig4_C_Envelope_Session.csv'
SaveName <- 'Envelope_Depths_LFPvsMUAe.csv'

df3A.Envelope <- read.csv(fileIn)

# Section 2: Data Preprocessing
# Convert relevant columns to factors
df3A.Envelope <- within(df3A.Envelope, {
  Birds_Name <- factor(Name)
  Sex_Birds <- factor(Sex)
  Depth <- factor(Depth)
  Session <- factor(Session_Number)
})

# Summarize the data
summary(df3A.Envelope)

# Initialize Word document
doc <- read_docx()
doc <- body_add_par(doc, paste0('File: ', gsub('\\.csv$', '', SaveName)), style = "Normal")

# Section 3: Model Fitting and Analysis for Decoding Performance Comparison (LFP vs MUAe)
# Reshape data to long format for comparison of LFP and MUAe
df3A.Envelope.long <- pivot_longer(df3A.Envelope, cols = c("Perf_LFP", "Perf_MUAe"), names_to = 'Signal', values_to = 'Performance')

# Fit null and effect models for performance comparison
null_model <- lmer(Performance ~ Depth + (1 | Session), data = df3A.Envelope.long, REML = FALSE)
effect_model <- lmer(Performance ~ Signal * Depth + (1 | Session), data = df3A.Envelope.long, REML = FALSE)

# Perform ANOVA to compare models
anova_result <- anova(null_model, effect_model)
write.csv(anova_result, file = paste0(Save_Path, 'Stat_', SaveName, '_LFP_MUAe_anova_result.csv'))

# Extract and format ANOVA and effect size results
chi_square <- anova_result[2, "Chisq"]
df <- anova_result[2, "Df"]
p_value <- anova_result[2, "Pr(>Chisq)"]
delta_r <- fixef(effect_model)["(Intercept)"]
se <- sqrt(vcov(effect_model)["(Intercept)", "(Intercept)"])

formatted_result <- sprintf('χ^2 (%d) = %.2f, p = %.8f; Δr = %.2f ± %.3f SE', 
                            df, chi_square, p_value, delta_r, se)
doc <- body_add_par(doc, paste0("**Decoding Performance Comparison (LFP vs MUAe): ", formatted_result, "**"), style = "Normal")

# Conduct post hoc analysis only if ANOVA is significant
if (p_value < significance_level) {
  posthoc <- emmeans(effect_model, ~ Signal | Depth)
  posthoc_contrast <- as.data.frame(contrast(posthoc, method = "pairwise"))
  significant_contrast <- posthoc_contrast[posthoc_contrast$p.value < significance_level, ]
  write.csv(significant_contrast, file = paste0(Save_Path, 'Stat_', SaveName, '_LFP_MUAe_posthoc_analysis.csv'))
}

# Section 4: Save Results in Word Format
print(doc, target = paste0(Save_Path, 'Stat_', SaveName, '_results.docx'))

# Visualization of Decoding Performance by Depth
library(ggplot2)
emmip(posthoc, ~ Depth | Signal) + 
  theme_minimal() +
  labs(title = "Decoding Performance by Signal Type and Recording Depth",
       y = "Estimated Performance",
       x = "Depth")
