######################################
## Figure 3 - Part A -PeakRate - Comparison of LFP with MUAe performance for decoding song temporal features (Trials) 
######################################


# Load necessary libraries
library(lme4)
library(officer)
library(flextable)

# Define paths
Load_Path <- '.../Figure 3/Data/'
Save_Path <- '.../Figure 3/Data/Stat Results/'

# Set working directory and load data
setwd(Load_Path)
fileIn <- 'Fig3_A_3.csv'
SaveName <- 'PeakRate.csv'
df3A.Landmarks <- read.csv(fileIn)

# Convert columns to factors
df3A.Landmarks$Birds_Name <- factor(df3A.Landmarks$Birds_Name)
df3A.Landmarks$Sex_Birds <- factor(df3A.Landmarks$Sex_Birds)
df3A.Landmarks$Song_Number <- factor(df3A.Landmarks$Song_Number)
df3A.Landmarks$Order_Parts <- factor(df3A.Landmarks$Order_Parts)
df3A.Landmarks$Session_Number <- factor(df3A.Landmarks$Session_Number)

# Summarize the data
summary(df3A.Landmarks)

# Fit null and effect models
null_model <- lmer('(Acc_PeakRate_MUAe - Acc_PeakRate_LFP) ~ -1 + (1 | Session_Number)', data = df3A.Landmarks)
effect_model <- lmer('(Acc_PeakRate_MUAe - Acc_PeakRate_LFP) ~ 1 + (1 | Session_Number)', data = df3A.Landmarks)

# Perform ANOVA to compare models
anova_result <- anova(null_model, effect_model)

# Extract summary from effect model
effect_model.sum <- summary(effect_model)

# Save the model output and ANOVA result to CSV files
write.csv(anova_result, file = paste0(Save_Path, 'Stat_', SaveName, '_anova_result.csv'))
write.csv(effect_model.sum$coefficients, file = paste0(Save_Path, 'Stat_', SaveName, '_effect_model_summary.csv'))

# Save effect model summary in a table format similar to R summary
effect_model_table <- as.data.frame(effect_model.sum$coefficients)
write.csv(effect_model_table, file = paste0(Save_Path, 'Stat_', SaveName, '_effect_model_summary_table.csv'))

# Print formatted results
chi_square <- anova_result[2, "Chisq"]
df <- anova_result[2, "Df"]
p_value <- anova_result[2, "Pr(>Chisq)"]

# Format p-value
p_value_formatted <- p_value

# Calculate delta r and standard error
delta_r <- effect_model.sum$coefficients[1, "Estimate"]
se <- effect_model.sum$coefficients[1, "Std. Error"]

# Print results in desired format
formatted_result_Perf1 <- sprintf('\u03C7^2 (%d) = %.2f, p = %s; Δr = %.2f ± %.3f SE', df, chi_square, p_value_formatted, delta_r, se)
print(paste0('**Performance 1 PeakRate : ', formatted_result_Perf1, '**'))

# Print from data (mean and standard error)
mean_diff <- mean(df3A.Landmarks$Acc_PeakRate_MUAe - df3A.Landmarks$Acc_PeakRate_LFP)
se_diff <- sd(df3A.Landmarks$Acc_PeakRate_MUAe - df3A.Landmarks$Acc_PeakRate_LFP) / sqrt(nrow(df3A.Landmarks))
formatted_result_data_Perf1 <- sprintf('From Data: Perf1 Difference MU - LFP = %.2f ± %.3f', mean_diff, se_diff)
print(formatted_result_data_Perf1)

# Fit null and effect models for Perf2
null_model_Perf2 <- lmer('(Acc_PeakEnv_MUAe - Acc_PeakEnv_LFP) ~ -1 + (1 | Session_Number)', data = df3A.Landmarks)
effect_model_Perf2 <- lmer('(Acc_PeakEnv_MUAe - Acc_PeakEnv_LFP) ~ 1 + (1 | Session_Number)', data = df3A.Landmarks)

# Perform ANOVA to compare Perf2 models
anova_result_Perf2 <- anova(null_model_Perf2, effect_model_Perf2)

# Extract summary from Perf2 effect model
effect_model_Perf2.sum <- summary(effect_model_Perf2)

# Save the Perf2 model output and ANOVA result to CSV files
write.csv(anova_result_Perf2, file = paste0(Save_Path, 'Stat_', SaveName, '_R2_anova_result.csv'))
write.csv(effect_model_Perf2.sum$coefficients, file = paste0(Save_Path, 'Stat_', SaveName, '_R2_effect_model_summary.csv'))

# Save Perf2 effect model summary in a table format similar to R summary
effect_model_R2_table <- as.data.frame(effect_model_Perf2.sum$coefficients)
write.csv(effect_model_R2_table, file = paste0(Save_Path, 'Stat_', SaveName, '_R2_effect_model_summary_table.csv'))

# Print formatted Perf2 results
chi_square_Perf2 <- anova_result_Perf2[2, "Chisq"]
df_Perf2 <- anova_result_Perf2[2, "Df"]
p_value_Perf2 <- anova_result_Perf2[2, "Pr(>Chisq)"]

# Format p-value for Perf2
p_value_R2_formatted <- p_value_Perf2

# Calculate delta r and standard error for Perf2
delta_r_Perf2 <- effect_model_Perf2.sum$coefficients[1, "Estimate"]
se_Perf2 <- effect_model_Perf2.sum$coefficients[1, "Std. Error"]

# Print Perf2 results in desired format
formatted_result_Perf2 <- sprintf('\u03C7^2 (%d) = %.2f, p = %s; Δr = %.2f ± %.3f SE', df_Perf2, chi_square_Perf2, p_value_R2_formatted, delta_r_Perf2, se_Perf2)
print(paste0('**Perf2 PeakRate Detection: ', formatted_result_Perf2, '**'))

# Print from data (mean and standard error) for Perf2
mean_diff_Perf2 <- mean(df3A.Landmarks$Acc_PeakEnv_MUAe - df3A.Landmarks$Acc_PeakEnv_LFP)
se_diff_Perf2 <- sd(df3A.Landmarks$Acc_PeakEnv_MUAe - df3A.Landmarks$Acc_PeakEnv_LFP) / sqrt(nrow(df3A.Landmarks))
formatted_result_data_Perf2 <- sprintf('From Data: Perf2 Difference MU - LFP = %.2f ± %.3f', mean_diff_Perf2, se_diff_Perf2)
print(formatted_result_data_Perf2)

# Create a new Word document
doc <- read_docx()   

doc <- body_add_par(doc, paste0('File: ', gsub('\\.csv$', '', SaveName)), style = "Normal")

# Add formatted results for Perf1 to Word
doc <- body_add_par(doc, formatted_result_Perf1, style = "Normal")
doc <- body_add_par(doc, formatted_result_data_Perf1, style = "Normal")

# Add formatted results for Perf2 to Word
doc <- body_add_par(doc, formatted_result_Perf2, style = "Normal")
doc <- body_add_par(doc, formatted_result_data_Perf2, style = "Normal")

# Save the Word document
print(doc, target = paste0(Save_Path, 'Stat_', SaveName, '_results.docx'))

