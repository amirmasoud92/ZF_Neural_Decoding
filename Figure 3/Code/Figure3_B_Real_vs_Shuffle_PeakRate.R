######################################
## Figure 3 - Part B - PeakRate Detection - LFP & MUAe - Real vs Shuffle PeakRate
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
fileIn <- 'Fig3_B_3.csv'
SaveName <- 'PeakRateRealvsShuffle.csv'

df3A.event <- read.csv(fileIn)

# Convert columns to factors
df3A.event$Birds_Name <- factor(df3A.event$Bird_Name)
df3A.event$Sex_Birds <- factor(df3A.event$Sex)

# Summarize the data
summary(df3A.event)

# Fit null and effect models
null_model <- lmer('(Acc_LFP_PeakRate - AccShuffle_LFP_PeakRate) ~ -1 + (1 | Birds_Name)', data = df3A.event)
effect_model <- lmer('(Acc_LFP_PeakRate - AccShuffle_LFP_PeakRate) ~ 1 + (1 | Birds_Name)', data = df3A.event)

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
formatted_result_acc <- sprintf('\u03C7^2 (%d) = %.2f, p = %s; Δr = %.2f ± %.3f SE', df, chi_square, p_value_formatted, delta_r, se)
print(paste0('**Accuracy Event : ', formatted_result_acc, '**'))

# Print from data (mean and standard error)
mean_diff <- mean(df3A.event$Acc_LFP_PeakRate - df3A.event$AccShuffle_LFP_PeakRate)
se_diff <- sd(df3A.event$Acc_LFP_PeakRate - df3A.event$AccShuffle_LFP_PeakRate) / sqrt(nrow(df3A.event))
formatted_result_data_acc <- sprintf('From Data: Acc Difference LFP - Shuffle = %.2f ± %.3f', mean_diff, se_diff)
print(formatted_result_data_acc)

# Fit null and effect models for Cohen
null_model_cohen <- lmer('(Acc_MUAe_PeakRate - AccShuffle_MUAe_PeakRate) ~ -1 + (1 | Birds_Name)', data = df3A.event)
effect_model_cohen <- lmer('(Acc_MUAe_PeakRate - AccShuffle_MUAe_PeakRate) ~ 1 + (1 | Birds_Name)', data = df3A.event)

# Perform ANOVA to compare Cohen models
anova_result_cohen <- anova(null_model_cohen, effect_model_cohen)

# Extract summary from Cohen effect model
effect_model_cohen.sum <- summary(effect_model_cohen)

# Save the Cohen model output and ANOVA result to CSV files
write.csv(anova_result_cohen, file = paste0(Save_Path, 'Stat_', SaveName, '_cohen_anova_result.csv'))
write.csv(effect_model_cohen.sum$coefficients, file = paste0(Save_Path, 'Stat_', SaveName, '_cohen_effect_model_summary.csv'))

# Save Cohen effect model summary in a table format similar to R summary
effect_model_cohen_table <- as.data.frame(effect_model_cohen.sum$coefficients)
write.csv(effect_model_cohen_table, file = paste0(Save_Path, 'Stat_', SaveName, '_cohen_effect_model_summary_table.csv'))

# Print formatted Cohen results
chi_square_cohen <- anova_result_cohen[2, "Chisq"]
df_cohen <- anova_result_cohen[2, "Df"]
p_value_cohen <- anova_result_cohen[2, "Pr(>Chisq)"]

# Format p-value for Cohen
p_value_formatted <- p_value_cohen

# Calculate delta r and standard error for Cohen
delta_r_cohen <- effect_model_cohen.sum$coefficients[1, "Estimate"]
se_cohen <- effect_model_cohen.sum$coefficients[1, "Std. Error"]

# Print Cohen results in desired format
formatted_result_cohen <- sprintf('\u03C7^2 (%d) = %.2f, p = %s; Δr = %.2f ± %.3f SE', df_cohen, chi_square_cohen, p_value_formatted, delta_r_cohen, se_cohen)
print(paste0('**Cohen Event Detection: ', formatted_result_cohen, '**'))

# Print from data (mean and standard error) for Cohen
mean_diff_cohen <- mean(df3A.event$Acc_MUAe_PeakRate - df3A.event$AccShuffle_MUAe_PeakRate)
se_diff_cohen <- sd(df3A.event$Acc_MUAe_PeakRate - df3A.event$AccShuffle_MUAe_PeakRate) / sqrt(nrow(df3A.event))
formatted_result_data_cohen <- sprintf('From Data: Cohen Difference LFP - Shuffle = %.2f ± %.3f', mean_diff_cohen, se_diff_cohen)
print(formatted_result_data_cohen)

# Create a new Word document
doc <- read_docx()
doc <- body_add_par(doc, paste0('File: ', gsub('\\.csv$', '', SaveName)), style = "Normal")

# Add formatted results for Acc to Word
doc <- body_add_par(doc, formatted_result_acc, style = "Normal")
doc <- body_add_par(doc, formatted_result_data_acc, style = "Normal")

# Add formatted results for Cohen to Word
doc <- body_add_par(doc, formatted_result_cohen, style = "Normal")
doc <- body_add_par(doc, formatted_result_data_cohen, style = "Normal")

# Save the Word document
print(doc, target = paste0(Save_Path, 'Stat_', SaveName, '_results.docx'))

