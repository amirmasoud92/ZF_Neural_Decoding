library(lme4)

# Define paths
Load_Path <- '.../Figure 3/Data/'
Save_Path <- '.../Figure 3/Data/Stat Results/'

setwd(Load_Path)

fileIn <- 'Fig3_A_1.csv'
df3A.event <- read.csv(fileIn)

# Convert columns to factors
df3A.event$Birds_Name <- factor(df3A.event$Birds_Name)
df3A.event$Sex_Birds <- factor(df3A.event$Sex_Birds)
df3A.event$Song_Number <- factor(df3A.event$Song_Number)
df3A.event$Order_Parts <- factor(df3A.event$Order_Parts)
df3A.event$Session_Number <- factor(df3A.event$Session_Number)

# Summarize the data
summary(df3A.event)

# Fit null and effect models
null_model <- lmer('(Acc_MUAe - Acc_LFP) ~ -1 + (1 | Session_Number)', data = df3A.event)
effect_model <- lmer('(Acc_MUAe - Acc_LFP) ~ 1 + (1 | Session_Number)', data = df3A.event)

# Perform ANOVA to compare models
anova_result <- anova(null_model, effect_model)

# Extract summary from effect model
effect_model.sum <- summary(effect_model)

# Save the model output and ANOVA result to CSV files
write.csv(anova_result, file = paste0(Save_Path, 'Stat_', fileIn, '_anova_result.csv'))
write.csv(effect_model.sum$coefficients, file = paste0(Save_Path, 'Stat_', fileIn, '_effect_model_summary.csv'))

# Print formatted results
chi_square <- anova_result[2, "Chisq"]
df <- anova_result[2, "Df"]
p_value <- anova_result[2, "Pr(>Chisq)"]

p_value_formatted <- ifelse(p_value < 0.001, "<0.001", format(p_value, digits = 5))

# Calculate delta r and standard error
delta_r <- effect_model.sum$coefficients[1, "Estimate"]
se <- effect_model.sum$coefficients[1, "Std. Error"]

# Print results in desired format
print(sprintf('\u03C7^2 (%d) = %.2f, p = %s; Δr = %.2f ± %.3f SE', df, chi_square, p_value_formatted, delta_r, se))

# Print from data (mean and standard error)
mean_diff <- mean(df3A.event$Acc_MUAe - df3A.event$Acc_LFP)
se_diff <- sd(df3A.event$Acc_MUAe - df3A.event$Acc_LFP) / sqrt(nrow(df3A.event))
print(sprintf('From Data: Acc Difference MU - LFP = %.2f ± %.3f', mean_diff, se_diff))

# Cohen analysis
null_model_cohen <- lmer('(Cohen_MUAe - Cohen_LFP) ~ -1 + (1 | Session_Number)', data = df3A.event)
effect_model_cohen <- lmer('(Cohen_MUAe - Cohen_LFP) ~ 1 + (1 | Session_Number)', data = df3A.event)

# Perform ANOVA to compare Cohen models
anova_result_cohen <- anova(null_model_cohen, effect_model_cohen)

# Extract summary from Cohen effect model
effect_model_cohen.sum <- summary(effect_model_cohen)

# Save the Cohen model output and ANOVA result to CSV files
write.csv(anova_result_cohen, file = paste0(Save_Path, 'Stat_', fileIn, '_cohen_anova_result.csv'))
write.csv(effect_model_cohen.sum$coefficients, file = paste0(Save_Path, 'Stat_', fileIn, '_cohen_effect_model_summary.csv'))

# Print formatted Cohen results
chi_square_cohen <- anova_result_cohen[2, "Chisq"]
df_cohen <- anova_result_cohen[2, "Df"]
p_value_cohen <- anova_result_cohen[2, "Pr(>Chisq)"]

# Format p-value for Cohen
p_value_cohen_formatted <- ifelse(p_value_cohen < 0.001, "<0.001", format(p_value_cohen, digits = 5))

# Calculate delta r and standard error for Cohen
delta_r_cohen <- effect_model_cohen.sum$coefficients[1, "Estimate"]
se_cohen <- effect_model_cohen.sum$coefficients[1, "Std. Error"]

# Print Cohen results in desired format
print(sprintf('\u03C7^2 (%d) = %.2f, p = %s; Δr = %.2f ± %.3f SE', df_cohen, chi_square_cohen, p_value_cohen_formatted, delta_r_cohen, se_cohen))

# Print from data (mean and standard error) for Cohen
mean_diff_cohen <- mean(df3A.event$Cohen_MUAe - df3A.event$Cohen_LFP)
se_diff_cohen <- sd(df3A.event$Cohen_MUAe - df3A.event$Cohen_LFP) / sqrt(nrow(df3A.event))
print(sprintf('From Data: Cohen Difference MU - LFP = %.2f ± %.3f', mean_diff_cohen, se_diff_cohen))

