# Load necessary libraries
library(tidyverse)
library(lme4)
library(officer)
library(emmeans)
library(ggplot2)

# Set options to adjust limit for large datasets
emm_options(pbkrtest.limit = 7320, lmerTest.limit = 7320)

# Define significance threshold
significance_level <- 0.05

# Section 1: Define paths and load data
load_path <- 'C:/Amir/Phd research/Article Phd/Thesis/Ahmadi et al 1/Data Figures/New/'
save_path <- 'C:/Amir/Phd research/Article Phd/Thesis/Ahmadi et al 1/Statistical Analysis/Results/'

# Load data
df3a_event <- read.csv(file.path(load_path, 'Fig4_C_Event_Session.csv'))

# Section 2: Data Preprocessing
# Convert relevant columns to factors
df3a_event <- df3a_event %>% 
  mutate(
    Birds_Name = factor(Name),
    Sex_Birds = factor(Sex),
    Depth = factor(Depth),
    Session = factor(Session_Number)
  )

# Summarize the data
summary(df3a_event)

# Initialize Word document
doc <- read_docx() %>% 
  body_add_par(paste0('File: ', gsub('\\.csv$', '', 'Event_Depths_LFPvsMUAe.csv')), style = "Normal")

# Section 3: Model Fitting and Analysis for Decoding Performance Comparison (LFP vs MUAe)
# Reshape data to long format for comparison of LFP and MUAe
df3a_event_long <- df3a_event %>% 
  pivot_longer(cols = c("Perf_LFP", "Perf_MUAe"), names_to = 'Signal', values_to = 'Performance')

# Fit null and effect models for performance comparison
null_model <- lmer(Performance ~ Depth + (1 | Birds_Name), data = df3a_event_long, REML = FALSE)
effect_model <- lmer(Performance ~ Signal * Depth + (1 | Birds_Name), data = df3a_event_long, REML = FALSE)

# Perform ANOVA to compare models
anova_result <- anova(null_model, effect_model)
write.csv(anova_result, file = file.path(save_path, 'Stat_Event_Depths_LFPvsMUAe_anova_result.csv'))

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
  # Perform pairwise comparisons for each depth between LFP and MUAe
  posthoc <- emmeans(effect_model, pairwise ~ Signal | Depth)
  posthoc_contrast <- as.data.frame(posthoc$contrasts)
  
  # Filter significant contrasts based on the specified significance level
  significant_contrast <- posthoc_contrast %>% filter(p.value < significance_level)
  
  # Save the pairwise comparison results to CSV
  write.csv(significant_contrast, file = file.path(save_path, 'Stat_Event_Depths_LFPvsMUAe_pairwise_comparison.csv'))
}

# Section 4: Save Results in Word Format
print(doc, target = file.path(save_path, 'Stat_Event_Depths_LFPvsMUAe_results.docx'))

# Visualization of Decoding Performance by Depth
emmip_plot <- emmip(posthoc$emmeans, Depth ~ Signal) + 
  theme_minimal() +
  labs(
    title = "Decoding Performance by Signal Type and Recording Depth",
    y = "Estimated Performance",
    x = "Depth"
  )
print(emmip_plot)
