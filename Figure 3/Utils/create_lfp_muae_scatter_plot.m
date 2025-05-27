function create_lfp_muae_scatter_plot(lfp_accuracy, muae_accuracy, varargin)
% CREATE_LFP_MUAE_SCATTER_PLOT - Generate scatter plot
% comparing LFP and MUAe accuracies with correlation analysis
%
% Syntax:
%   create_lfp_muae_scatter_plot(lfp_accuracy, muae_accuracy)
%   create_lfp_muae_scatter_plot(lfp_accuracy, muae_accuracy, 'Parameter', Value)
%
% Inputs:
%   lfp_accuracy  - Vector of LFP accuracy values (x-axis)
%   muae_accuracy - Vector of MUAe accuracy values (y-axis)
%
% Optional Parameters:
%   'MarkerSize'     - Size of scatter points (default: 80)
%   'MarkerColor'    - Color of scatter points (default: [0.2 0.4 0.8])
%   'Alpha'          - Transparency of points (default: 0.7)
%   'FontSize'       - Font size for labels (default: 14)
%   'TitleFontSize'  - Font size for title (default: 16)
%   'LineWidth'      - Width of regression line (default: 2)
%   'ShowConfInt'    - Show confidence intervals (default: true)
%   'SaveFig'        - Save figure (default: false)
%   'FigureName'     - Name for saved figure (default: 'LFP_MUAe_comparison')
%   'DPI'            - Resolution for saved figure (default: 300)

% Parse input arguments
p = inputParser;
addRequired(p, 'lfp_accuracy', @(x) isnumeric(x) && isvector(x));
addRequired(p, 'muae_accuracy', @(x) isnumeric(x) && isvector(x));
addParameter(p, 'MarkerSize', 80, @(x) isnumeric(x) && isscalar(x));
addParameter(p, 'MarkerColor', [0.2 0.4 0.8], @(x) isnumeric(x));
addParameter(p, 'Alpha', 0.7, @(x) isnumeric(x) && isscalar(x));
addParameter(p, 'FontSize', 14, @(x) isnumeric(x) && isscalar(x));
addParameter(p, 'TitleFontSize', 16, @(x) isnumeric(x) && isscalar(x));
addParameter(p, 'LineWidth', 2, @(x) isnumeric(x) && isscalar(x));
addParameter(p, 'ShowConfInt', true, @(x) islogical(x));
addParameter(p, 'SaveFig', false, @(x) islogical(x));
addParameter(p, 'FigureName', 'LFP_MUAe_comparison', @(x) ischar(x) || isstring(x));
addParameter(p, 'DPI', 300, @(x) isnumeric(x) && isscalar(x));

parse(p, lfp_accuracy, muae_accuracy, varargin{:});

% Extract parsed parameters
lfp_acc = p.Results.lfp_accuracy(:);
muae_acc = p.Results.muae_accuracy(:);
marker_size = p.Results.MarkerSize;
marker_color = p.Results.MarkerColor;
alpha_val = p.Results.Alpha;
font_size = p.Results.FontSize;
title_font_size = p.Results.TitleFontSize;
line_width = p.Results.LineWidth;
show_conf_int = p.Results.ShowConfInt;
save_fig = p.Results.SaveFig;
fig_name = p.Results.FigureName;
dpi = p.Results.DPI;

% Validate input data
if length(lfp_acc) ~= length(muae_acc)
    error('LFP and MUAe accuracy vectors must have the same length');
end

% Remove NaN values
valid_idx = ~isnan(lfp_acc) & ~isnan(muae_acc);
lfp_acc = lfp_acc(valid_idx);
muae_acc = muae_acc(valid_idx);

if length(lfp_acc) < 3
    error('At least 3 valid data points required for correlation analysis');
end

% Statistical calculations
[r, p_val] = corr(lfp_acc, muae_acc, 'Type', 'Pearson');
n = length(lfp_acc);

% Calculate Cohen's d effect size
pooled_std = sqrt((std(lfp_acc)^2 + std(muae_acc)^2) / 2);
cohens_d = abs(mean(lfp_acc) - mean(muae_acc)) / pooled_std;

% Calculate 95% confidence interval for correlation
fisher_z = 0.5 * log((1 + r) / (1 - r));
se_z = 1 / sqrt(n - 3);
ci_z = fisher_z + [-1.96, 1.96] * se_z;
ci_r = (exp(2 * ci_z) - 1) ./ (exp(2 * ci_z) + 1);



% Create figure with optimal dimensions
fig = figure('Position', [100, 100, 800, 700], 'Color', 'white');
ax = axes('Parent', fig);

% Create scatter plot
hold on;


% Plot unity line (diagonal where x = y)
data_range = [min([lfp_acc; muae_acc]), max([lfp_acc; muae_acc])];
plot(data_range, data_range, '-', 'Color', [0.5, 0.5, 0.5], ...
     'LineWidth', 4, 'DisplayName', 'Unity Line');


% Create scatter plot with transparency
scatter(lfp_acc, muae_acc, marker_size, marker_color, 'filled', ...
        'MarkerFaceAlpha', alpha_val, 'MarkerEdgeColor', 'none');

hold off;

% Formatting
axis equal;
axis tight;

% Set axis limits with padding
x_range = max(lfp_acc) - min(lfp_acc);
y_range = max(muae_acc) - min(muae_acc);
padding = 0.05;

xlim([min(lfp_acc) - x_range * padding, max(lfp_acc) + x_range * padding]);
ylim([min(muae_acc) - y_range * padding, max(muae_acc) + y_range * padding]);

% Labels and title
xlabel('LFP Perf', 'FontSize', font_size, 'FontWeight', 'bold');
ylabel('MUAe Perf', 'FontSize', font_size, 'FontWeight', 'bold');

% Create comprehensive title with statistics
if p_val < 0.001
    p_str = 'p < 0.001';
else
    p_str = sprintf('p = %.3f', p_val);
end

effect_size_label = get_effect_size_label(cohens_d);

title_str = sprintf(['r = %.3f [%.3f, %.3f] | %s, d = %.2f (%s), n = %d'], ...
                    r, ci_r(1), ci_r(2), p_str, cohens_d, effect_size_label, n);

title(title_str, 'FontSize', title_font_size, 'FontWeight', 'bold');

% Grid and styling
set(ax, 'FontSize', font_size - 2);
set(ax, 'LineWidth', 2);
box off;




% Adjust figure properties for publication
set(fig, 'PaperPositionMode', 'auto');
set(fig, 'InvertHardcopy', 'off');

% Save figure if requested
if save_fig
    % Save as high-resolution PNG
    print(fig, [fig_name, '.png'], '-dpng', ['-r', num2str(dpi)]);
    
    % Save as vector format (EPS) for publications
    print(fig, [fig_name, '.eps'], '-depsc2', '-painters');
    
    % Save as MATLAB figure
    savefig(fig, [fig_name, '.fig']);
    
    fprintf('Figure saved as:\n');
    fprintf('  - %s.png (raster, %d DPI)\n', fig_name, dpi);
    fprintf('  - %s.eps (vector)\n', fig_name);
    fprintf('  - %s.fig (MATLAB)\n', fig_name);
end

% Display results
fprintf('====================================\n\n');
fprintf('\n=== Correlation Analysis Results ===\n');
fprintf('Pearson correlation coefficient: r = %.4f\n', r);
fprintf('95%% Confidence interval: [%.4f, %.4f]\n', ci_r(1), ci_r(2));
fprintf('P-value: %s\n', p_str);
fprintf('Cohen''s d effect size: %.4f (%s)\n', cohens_d, effect_size_label);
fprintf('Sample size: n = %d\n', n);
fprintf('====================================\n\n');

end

function label = get_effect_size_label(d)
% Get Cohen's d effect size interpretation
if d < 0.2
    label = 'negligible';
elseif d < 0.5
    label = 'small';
elseif d < 0.8
    label = 'medium';
else
    label = 'large';
end
end

function [y_pred, delta] = polyconf(p, x, ss_res, df)
% Calculate confidence intervals for polynomial regression
n = length(x);
mse = ss_res / df;
x_mean = mean(x);
ssx = sum((x - x_mean).^2);

y_pred = polyval(p, x);
se = sqrt(mse * (1/n + (x - x_mean).^2 / ssx));
t_crit = tinv(0.975, df);
delta = t_crit * se;
end