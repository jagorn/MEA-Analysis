function [non_linearity, x] = estimateNL(cell_id, exp_id, binarize_spikes, do_plots)

if ~exist('binarize_spikes', 'var')
    binarize_spikes = true;
end

if ~exist('do_plots', 'var')
    do_plots = false;
end

% Parameters
time_bin = 0.05;

%Load data
exp_file = fullfile("Data", strcat(exp_id, ".mat"));
load(exp_file, 'mea_rate', 'rep_begin');
load(exp_file, 'SpikeTimes', 'temporal', 'Valid_STAs_idx');
load(exp_file, 'euler', 'euler_freq', 'euler_polarity_inverse', 'euler_onset_idx', 'euler_offset_idx');

% Normalization of Chirp Stimulus
if euler_polarity_inverse
    euler = 256 - euler;
end
euler = euler(euler_onset_idx:euler_offset_idx);
euler = euler / max(euler);
euler = euler - 0.5;
euler_x = (1/euler_freq):(1/euler_freq):(numel(euler)/euler_freq);

% Repetitions
StartTime = rep_begin + euler_onset_idx / euler_freq * mea_rate;
EndTime  = rep_begin + euler_offset_idx / euler_freq * mea_rate;

bin_size = time_bin * mea_rate;
n_bins = round(median(EndTime - StartTime) / bin_size);

% Cell data
if ~any(Valid_STAs_idx == cell_id)
    error(strcat("Cell #", num2str(cell_id), " doesn't have a valid STA"));
end

[psth, xpsth, ~, ~] = doPSTH(SpikeTimes, StartTime, bin_size, n_bins,  mea_rate, 1:numel(SpikeTimes));
spikes = SpikeTimes{cell_id};
t_sta = temporal(cell_id,:);

% Compute temporal filters based on temporal components of the STAs
t_filter = t_sta - 0.5;
t_filter = t_filter / max(abs(t_filter));

% Convolution
generator = zeros(1, length(euler));
for i = 1:length(euler)
    generator(i) = 0;
    for j = 1:min(length(t_filter), i)
        generator(i) = generator(i) + euler(i-j+1) * t_filter(end-j+1);
    end
end

FullDistrVal = generator; % Values taken by g, used to have the distribution.
CondVal = [];

%Extract over trials the values forming the p(g | spike) conditional distribution.
n_repetitions = length(StartTime);
for i = 1:n_repetitions
    spikes_repetition = spikes(spikes >= StartTime(i) & spikes <= EndTime(i)) - StartTime(i);
    spikes_indices = ceil(spikes_repetition / (mea_rate/euler_freq) );
    spikes_indices(spikes_indices == 0) = [];
    
    if binarize_spikes
        spikes_indices = unique(spikes_indices);
    end
    
    CondVal = [CondVal  generator(spikes_indices)];
end


%Build the distributions
bin_edges = linspace(-1.0, 2.0, 20);
x = bin_edges(2:end);

p_spike = length(CondVal) / (length(FullDistrVal) * n_repetitions);
p_g = histcounts(FullDistrVal, bin_edges) / length(FullDistrVal);
p_g_given_spike = histcounts(CondVal, bin_edges) / length(CondVal);

%Estimate the non-linearity from bias rule as p(spike | g) = p(g | spike) * p(spike)  / p(g)
non_linearity = p_spike * p_g_given_spike ./ p_g;

%Fit only using values of the conditional distribution above 0.
% Also excludes the nan values.
non_linearity_def_idx = ~isnan(non_linearity);
non_linearity_to_fit_x = x(non_linearity_def_idx);
non_linearity_to_fit_y = non_linearity(non_linearity_def_idx);

if do_plots
    % p contains the three parameters of the exponential function.
    x0 = [0,0,0];
    funExp = @(x, xdata)(x(1) * exp(x(2) * xdata) + x(3));
    [params_exp_fit, residual] = lsqcurvefit(funExp, x0, non_linearity_to_fit_x, non_linearity_to_fit_y);
    
    % plots
    euler_plot = (euler + 0.5) * max(psth(cell_id, :));
    t_filter_x = (1/euler_freq):(1/euler_freq):(numel(t_filter)/euler_freq);
    
    figure;
    fullScreen();
    subplot(2, 3, 1);
    plot(t_filter_x, t_filter, 'LineWidth', 1.5);
    ylim([-1.1, 1.1]);
    xlim([min(t_filter_x), max(t_filter_x)]);
    title(" Linear Filter (from temporal STA)");
    xlabel('Time (s)');
    ylabel('Coefficient (a.u.)');
    
    subplot(2, 3, 2);
    hold on;
    plot(x, p_g, 'b', 'LineWidth', 1.5);
    plot(x, p_g_given_spike, 'r', 'LineWidth', 1.5);
    xlim([min(x), max(x)]);
    title("Prior and Likelihood");
    xlabel('generator signal values');
    ylabel('probability');
    legend({'p(g)', 'p(g|spike)'}, 'location', 'northwest');
    
    subplot(2, 3, 3);
    hold on;
    plot(x, non_linearity, 'k', 'LineWidth', 1.5);
    plot(non_linearity_to_fit_x, funExp(params_exp_fit, non_linearity_to_fit_x), 'r', 'LineWidth', 1.5);
    xlim([min(x), max(x)]);
    ylim([-0.1, 1]);
    title(" Non-Linearity");
    xlabel('generator signal values');
    ylabel('probability');
    legend({'empirical p(spike|g)', 'fitted p(spike|g)'}, 'location', 'northwest');
    
    subplot(2, 3, [4 5]);
    hold on;
    plot(euler_x, euler_plot, 'Color', [0.5, 0.5, 0.5, 0.5], 'LineWidth', 1.5)
    plot(xpsth, psth(cell_id, :), 'Color', 'blue', 'LineWidth', 1.5)
    xlim([min(euler_x), max(euler_x)]);
    title('PSTH to Chirp');
    xlabel('Time (s)');
    ylabel('Firing Rate (Hz)');
    legend({'Chirp Luminance', 'Psth'});
    
    subplot(2, 3, 6);
    params_text = { "Fitted Parameters:   a * EXP(b * X) + c", ...
        "", ...
        strcat("a = ", num2str(params_exp_fit(1))), ...
        strcat("b = ", num2str(params_exp_fit(2))), ...
        strcat("c = ", num2str(params_exp_fit(3))), ...
        "", ...
        strcat("Residual = ", num2str(residual))};
    
    text(-1, 0, params_text, 'FontSize',14)
    xlim([-1, 1]);
    ylim([-1, 1]);
    axis off;
    
    suptitle(strcat("Experiment ", exp_id, " Cell #", num2str(cell_id)));
end
