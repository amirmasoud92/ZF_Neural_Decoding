######################################
## Figure S6 - LFP - Event Detection - Comparison of decoding performance of temporal song features based on playback order within each session.
######################################

# Load necessary libraries
library(lme4)
library(officer)
library(flextable)

# Section 1: Define paths and load data
Load_Path <- '...'
Save_Path <- '...'

# Set working directory and load data
setwd(Load_Path)
fileIn <- 'FigS6_Event.csv'
SaveName <- 'Event_OrderParts.csv'

df3A.event <- read.csv(fileIn)

# Section 2: Data Preprocessing
# Convert relevant columns to factors
df3A.event <- within(df3A.event, {
  Birds_Name <- factor(Name)
  Sex_Birds <- factor(Sex)
  Session_Number <- factor(Session)
  Depth <- factor(Depth)
  Parts <- factor(OrderParts)
})

# Summarize the data
summary(df3A.event)

# Section 3: Model Fitting and Analysis for LFP Performance
# Fit null and effect models
null_model <- lmer(LFP_Perf ~ Depth + (1 | Birds_Name), data = df3A.event)
effect_model <- lmer(LFP_Perf ~ Parts + Depth + (1 | Birds_Name), data = df3A.event)

# Perform ANOVA to compare models
anova_result <- anova(null_model, effect_model)

# Extract summary from effect model
effect_model_summary <- summary(effect_model)

# Save the model output and ANOVA result to CSV files
write.csv(anova_result, file = paste0(Save_Path, 'Stat_', SaveName, '_anova_result.csv'))
write.csv(effect_model_summary$coefficients, file = paste0(Save_Path, 'Stat_', SaveName, '_effect_model_summary.csv'))

# Section 4: Print Formatted Results for LFP Performance
chi_square <- anova_result[2, "Chisq"]
df <- anova_result[2, "Df"]
p_value <- anova_result[2, "Pr(>Chisq)"]

# Calculate delta r and standard error
delta_r <- effect_model_summary$coefficients[1, "Estimate"]
se <- effect_model_summary$coefficients[1, "Std. Error"]

# Print formatted results
formatted_result_acc <- sprintf('χ^2 (%d) = %.2f, p = %.3f; Δr = %.2f ± %.3f SE', df, chi_square, p_value, delta_r, se)
print(paste0('**LFP Event: ', formatted_result_acc, '**'))

# Section 5: Model Fitting and Analysis for MUAe Performance
null_model_muae <- lmer(MUAe_Perf ~ Depth + (1 | Birds_Name), data = df3A.event)
effect_model_muae <- lmer(MUAe_Perf ~ Parts + Depth + (1 | Birds_Name), data = df3A.event)

# Perform ANOVA to compare models
anova_result_muae <- anova(null_model_muae, effect_model_muae)

# Extract summary from effect model
effect_model_muae_summary <- summary(effect_model_muae)

# Save the MUAe model output and ANOVA result to CSV files
write.csv(anova_result_muae, file = paste0(Save_Path, 'Stat_', SaveName, '_muae_anova_result.csv'))
write.csv(effect_model_muae_summary$coefficients, file = paste0(Save_Path, 'Stat_', SaveName, '_muae_effect_model_summary.csv'))

# Section 6: Print Formatted Results for MUAe Performance
chi_square_muae <- anova_result_muae[2, "Chisq"]
df_muae <- anova_result_muae[2, "Df"]
p_value_muae <- anova_result_muae[2, "Pr(>Chisq)"]

# Calculate delta r and standard error for MUAe
delta_r_muae <- effect_model_muae_summary$coefficients[1, "Estimate"]
se_muae <- effect_model_muae_summary$coefficients[1, "Std. Error"]

# Print formatted results for MUAe
formatted_result_muae <- sprintf('χ^2 (%d) = %.2f, p = %.3f; Δr = %.2f ± %.3f SE', df_muae, chi_square_muae, p_value_muae, delta_r_muae, se_muae)
print(paste0('**MUAe Event Detection: ', formatted_result_muae, '**'))

# Section 7: Save Results in Word Format
doc <- read_docx()
doc <- body_add_par(doc, paste0('File: ', gsub('\\.csv$', '', SaveName)), style = "Normal")

# Add formatted results to Word
doc <- body_add_par(doc, formatted_result_acc, style = "Normal")
doc <- body_add_par(doc, formatted_result_muae, style = "Normal")

# Save the Word document
print(doc, target = paste0(Save_Path, 'Stat_', SaveName, '_results.docx'))
