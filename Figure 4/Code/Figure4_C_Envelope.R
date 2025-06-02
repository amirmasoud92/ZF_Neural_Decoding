# Load necessary libraries
library(lme4)
library(officer)
library(emmeans)

# Set options to adjust limit for large datasets
emm_options(pbkrtest.limit = 3660, lmerTest.limit = 3660)

# Define significance threshold
significance_level <- 0.05

# Section 1: Define paths and load data
Load_Path <- 'C:/Amir/Phd research/Article Phd/Thesis/Ahmadi et al 1/Data Figures/New/'
Save_Path <- 'C:/Amir/Phd research/Article Phd/Thesis/Ahmadi et al 1/Statistical Analysis/Results/'

# Set working directory and load data
setwd(Load_Path)
fileIn <- 'Fig4_C_Envelope.csv'
SaveName <- 'Fig4_Envelope_Depths.csv'

df3A.Envelope <- read.csv(fileIn)

# Section 2: Data Preprocessing
# Convert relevant columns to factors
df3A.Envelope <- within(df3A.Envelope, {
  Birds_Name <- factor(Birds)
  Sex_Birds <- factor(Sex)
  Depth <- factor(Depth)
  Session <- factor(Session)
})



# Summarize the data
summary(df3A.Envelope)

# Initialize Word document
doc <- read_docx()
doc <- body_add_par(doc, paste0('File: ', gsub('\\.csv$', '', SaveName)), style = "Normal")

# Section 3: Model Fitting and Analysis for LFP Performance
# Fit null and effect models for LFP
null_model_LFP <- lmer(Perf_LFP ~ 1 + (1 | Birds_Name), data = df3A.Envelope, REML = FALSE)
effect_model_LFP <- lmer(Perf_LFP ~ Depth + (1 | Birds_Name), data = df3A.Envelope, REML = FALSE)

# Perform ANOVA to compare models
anova_result_LFP <- anova(null_model_LFP, effect_model_LFP)
write.csv(anova_result_LFP, file = paste0(Save_Path, 'Stat_', SaveName, '_LFP_anova_result.csv'))

# Extract and format ANOVA and effect size results for LFP
chi_square <- anova_result_LFP[2, "Chisq"]
df <- anova_result_LFP[2, "Df"]
p_value <- anova_result_LFP[2, "Pr(>Chisq)"]
delta_r <- fixef(effect_model_LFP)["(Intercept)"]
se <- sqrt(vcov(effect_model_LFP)["(Intercept)", "(Intercept)"])

formatted_result_LFP <- sprintf('χ^2 (%d) = %.2f, p = %.8f; Δr = %.2f ± %.3f SE', 
                                df, chi_square, p_value, delta_r, se)
doc <- body_add_par(doc, paste0("**LFP Envelope: ", formatted_result_LFP, "**"), style = "Normal")

# Conduct post hoc analysis only if ANOVA is significant
if (p_value < significance_level) {
  posthoc_LFP <- emmeans(effect_model_LFP, ~ Depth)
  posthoc_contrast_LFP <- as.data.frame(contrast(posthoc_LFP, method = "pairwise"))
  significant_contrast_LFP <- posthoc_contrast_LFP[posthoc_contrast_LFP$p.value < significance_level, ]
  write.csv(significant_contrast_LFP, file = paste0(Save_Path, 'Stat_', SaveName, '_LFP_posthoc_analysis.csv'))
}

# Section 4: Model Fitting and Analysis for MUAe Performance
# Fit null and effect models for MUAe
null_model_MUAe <- lmer(Perf_MUAe ~ 1 + (1 | Birds_Name), data = df3A.Envelope, REML = FALSE)
effect_model_MUAe <- lmer(Perf_MUAe ~ Depth + (1 | Birds_Name), data = df3A.Envelope, REML = FALSE)

# Perform ANOVA to compare models
anova_result_MUAe <- anova(null_model_MUAe, effect_model_MUAe)
write.csv(anova_result_MUAe, file = paste0(Save_Path, 'Stat_', SaveName, '_MUAe_anova_result.csv'))

# Extract and format ANOVA and effect size results for MUAe
chi_square_muae <- anova_result_MUAe[2, "Chisq"]
df_muae <- anova_result_MUAe[2, "Df"]
p_value_muae <- anova_result_MUAe[2, "Pr(>Chisq)"]
delta_r_muae <- fixef(effect_model_MUAe)["(Intercept)"]
se_muae <- sqrt(vcov(effect_model_MUAe)["(Intercept)", "(Intercept)"])

formatted_result_MUAe <- sprintf('χ^2 (%d) = %.2f, p = %.8f; Δr = %.2f ± %.3f SE', 
                                 df_muae, chi_square_muae, p_value_muae, delta_r_muae, se_muae)
doc <- body_add_par(doc, paste0("**MUAe Envelope Detection: ", formatted_result_MUAe, "**"), style = "Normal")

# Conduct post hoc analysis only if ANOVA is significant
if (p_value_muae < significance_level) {
  posthoc_MUAe <- emmeans(effect_model_MUAe, ~ Depth)
  posthoc_contrast_MUAe <- as.data.frame(contrast(posthoc_MUAe, method = "tukey"))
  significant_contrast_MUAe <- posthoc_contrast_MUAe[posthoc_contrast_MUAe$p.value < significance_level, ]
  write.csv(significant_contrast_MUAe, file = paste0(Save_Path, 'Stat_', SaveName, '_MUAe_posthoc_analysis.csv'))
}

# Section 5: Save Results in Word Format
print(doc, target = paste0(Save_Path, 'Stat_', SaveName, '_results.docx'))


library(ggplot2)
emmip(posthoc_LFP, ~ Depth) + 
  theme_minimal() +
  labs(title = "Decoding Performance by Recording Depth",
       y = "Estimated Performance",
       x = "Depth")


