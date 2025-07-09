rm(list = ls())
if (!is.null(dev.list())) dev.off()

# Define load and save paths
load_path <- "..."
save_path <- "..."

library(lme4)
library(ggplot2)
library(lmerTest)  
library(Cairo)  
library(reshape2)
library(dplyr)  
library(effectsize) 

# Load the CSV data
data <- read.csv(file.path(load_path, "FigS10_ITPCz_Landmark.csv"))

# Ensure BirdsITPCz and SongITPCz are treated as categorical variables
data$BirdsITPCz <- as.factor(data$BirdsITPCz)
data$SongITPCz <- as.factor(data$SongITPCz)

# Fit the linear mixed model
lmm <- lmer(Perf_SessionSong ~ Delta_ITPCz + Theta_ITPCz + Alpha_ITPCz + Beta_ITPCz + Gamma_ITPCz + 
              (1 | BirdsITPCz) + (1 | SongITPCz), data = data)

# Summary of the model to check which frequency bands are significant
summary_lmm <- summary(lmm)

# Extract relevant statistics for each frequency band
coefs <- summary_lmm$coefficients
std_coefs <- effectsize::standardize_parameters(lmm)
output_text <- "\nSummary of Linear Mixed Model:\n"

for (band in rownames(coefs)) {
  if (band != "(Intercept)") {
    estimate <- round(coefs[band, "Estimate"], 2)
    se <- round(coefs[band, "Std. Error"], 2)
    t_value <- round(coefs[band, "t value"], 2)
    p_value <- signif(coefs[band, "Pr(>|t|)"], 3)
    ci_lower <- round(estimate - 1.96 * se, 2)
    ci_upper <- round(estimate + 1.96 * se, 2)
    std_effect <- round(std_coefs[std_coefs$Parameter == band, "Std_Coefficient"], 2)
    significance <- ifelse(p_value < 0.001, "***", ifelse(p_value < 0.01, "**", ifelse(p_value < 0.05, "*", "")))
    output_text <- paste0(output_text, sprintf("%s: Estimate = %s, SE = %s, t(%s) = %s, p = %s %s, 95%% CI [%s, %s], Std. Effect = %s\n", 
                                               band, estimate, se, summary_lmm$devcomp$dims["N"] - 1, t_value, p_value, significance, ci_lower, ci_upper, std_effect))
  }
}

# Save the output of statistical analysis to a .doc file
cat(output_text, file = paste0(save_path, "FigS10_Landmark__ITPCz_Linear_Mixed_Model_Summary.doc"))

write.csv(as.data.frame(coefs), file = paste0(save_path, "FigS10_Landmark__ITPCz_Model_Coefficients.csv"))

data_long <- melt(data, id.vars = c("Perf_SessionSong", "BirdsITPCz", "SongITPCz"), 
                  measure.vars = c("Delta_ITPCz", "Theta_ITPCz", "Alpha_ITPCz", "Beta_ITPCz", "Gamma_ITPCz"),
                  variable.name = "Frequency_Band", value.name = "ITPCz_Value")

data_long$Frequency_Band <- factor(data_long$Frequency_Band, levels = c("Delta_ITPCz", "Theta_ITPCz", "Alpha_ITPCz", "Beta_ITPCz", "Gamma_ITPCz"))

# Compute correlation values for each frequency band
cor_values <- data_long %>%
  group_by(Frequency_Band) %>%
  summarize(correlation = cor(ITPCz_Value, Perf_SessionSong))

# Save and display the correlation summary
cor_summary_text <- paste0(
  "Correlation Summary for Frequency Bands:\n",
  paste0(cor_values$Frequency_Band, ": r = ", round(cor_values$correlation, 2), collapse = "\n")
)
cat(cor_summary_text, file = paste0(save_path, "FigS10_ITPCz_PerfLandmark_Correlation.doc"))
cat(cor_summary_text)

################################################### PLOT Result #####################################

plot <- ggplot(data_long, aes(x = ITPCz_Value, y = Perf_SessionSong, color = Frequency_Band)) +
  geom_point(size = 2, alpha = 0.6) +
  
  geom_smooth(method = "lm", se = FALSE, linewidth = 1.2, alpha = 0.2) +
  
  labs(
    x = "ITPCz Value",
    y = "Performance (%)"
  ) +
  
  theme_minimal(base_size = 14) +
  
  scale_color_manual(
    values = c(
      "Delta_ITPCz" = "#ecb120",  
      "Theta_ITPCz" = "#ffa5b2",    
      "Alpha_ITPCz" = "#76ac42",    
      "Beta_ITPCz" = "#50beed",     
      "Gamma_ITPCz" = "#a21d31"     
    ),
    labels = c("δ", "θ", "α", "β", "γ")
  ) +
  
  theme(
    panel.background = element_rect(fill = "white", color = "black"),
    panel.grid.major = element_line(color = "grey97", linewidth = 0.1), 
    panel.grid.minor = element_blank(),
    
    axis.line = element_line(color = "black", linewidth = 0.5),
    axis.text = element_text(color = "black", size = 12),
    axis.title = element_text(color = "black", size = 14, face = "bold"),
    
    legend.position = "bottom",
    legend.title = element_blank(),
    legend.background = element_rect(fill = "white", color = "black", linewidth = 0.2),
    legend.key = element_rect(fill = "white"),
    legend.text = element_text(size = 12),
    legend.spacing.x = unit(0.2, "cm"),
    legend.margin = margin(t = 5, r = 5, b = 5, l = 5),
    
    plot.title = element_blank(),
    plot.margin = margin(t = 20, r = 20, b = 20, l = 20)
  ) +
  
  scale_x_continuous(
    limits = c(0, 10),
    breaks = seq(0, 10, 5)
  ) +
  scale_y_continuous(
    limits = c(0, 1),
    breaks = seq(0, 1, 0.3)
  )

# Save the plot with improved dimensions and resolution
CairoSVG(
  file = paste0(save_path, "FigS10_Landmark__ITPCz_Performance_vs_ITPCz.svg"), 
  width = 10, 
  height = 10, 
  pointsize = 12
)
print(plot)
dev.off()