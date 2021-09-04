
%Compute NL from Euler data
clear
close all

% Parameters
exp_id = "20170614";
euler_onset_idx = 3000;
euler_offset_idx = 5950;
mea_rate = 20000;
time_bin = 0.05;
rpv = 0.003; % refractory period violation;


%Load data
exp_file = fullfile("Data", strcat(exp_id, "_data", ".mat"));
load(exp_file);

% Normalization of Chirp Stimulus
euler = euler(euler_onset_idx:euler_offset_idx);
euler = euler / max(euler);
euler = euler - 0.5;
euler_x = (1/euler_freq):(1/euler_freq):(numel(euler)/euler_freq);

% Repetitions
StartTime = rep_begin + euler_onset_idx / euler_freq * mea_rate;
EndTime  = rep_begin + euler_offset_idx / euler_freq * mea_rate;

bin_size = time_bin * mea_rate;
n_bins = round(median(EndTime - StartTime) / bin_size);

% PSTHs
[psth, xpsth, ~, ~] = doPSTH(SpikeTimes, StartTime, bin_size, n_bins,  mea_rate, 1:numel(SpikeTimes));

% Pick one cell - you can have easily a for loop here
for cell_id = Valid_STAs_idx'
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
    for i = 1:length(StartTime)
        spikes_repetition = spikes(spikes >= StartTime(i) & spikes <= EndTime(i)) - StartTime(i);
        spikes_indices = ceil(spikes_repetition / (mea_rate/euler_freq) );
        
        CondVal = [CondVal  generator(spikes_indices)];
    end
    
    
    %Build the distributions
    x = linspace(min(FullDistrVal), max(FullDistrVal),25);
    
    p_spike = length(CondVal) / length(FullDistrVal);
    p_g = hist(FullDistrVal,x) / length(FullDistrVal);
    p_g_given_spike = hist(CondVal, x) / length(CondVal);
    
    %Estimate the non-linearity from bias rule as p(spike | g) = p(g | spike) * p(spike)  / p(g)
    non_linearity = p_spike * p_g_given_spike ./ p_g;
    
    %Fit only using values of the conditional distribution above 0.
    % Also excludes the nan values.
    non_linearity_positive_def = find(non_linearity>0);
    non_linearity_to_fit_x = x(non_linearity_positive_def);
    non_linearity_to_fit_y = non_linearity(non_linearity_positive_def);
    
    % p contains the three parameters of the exponential function.
    x0 = [0,0,0];
    funExp = @(x, xdata)(x(1) * exp(x(2) * xdata) + x(3));
    [p, residual] = lsqcurvefit(funExp, x0, non_linearity_to_fit_x, non_linearity_to_fit_y);
    
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
    legend({'p(g)', 'p(g|spike)'})
    
    subplot(2, 3, 3);
    hold on;
    plot(x, non_linearity, 'k', 'LineWidth', 1.5);
    plot(non_linearity_to_fit_x, funExp(p, non_linearity_to_fit_x), 'r', 'LineWidth', 1.5);
    xlim([min(x), max(x)]);
    title(" Non-Linearity");
    xlabel('generator signal values');
    ylabel('non-linear thresholding');
    legend({'empirical', 'fitted exp'})
    
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
    params_text = { "Fit Parameters:   a * EXP(b * X) + c", ...
        "", ...
        strcat("a = ", num2str(p(1))), ...
        strcat("b = ", num2str(p(2))), ...
        strcat("c = ", num2str(p(3))), ...
        "", ...
        strcat("Residual = ", num2str(residual))};
    
    text(-1, 0, params_text, 'FontSize',14)
    xlim([-1, 1]);
    ylim([-1, 1]);
    axis off;
    
    suptitle(strcat("Experiment ", exp_id, " Cell #", num2str(cell_id)));
    waitforbuttonpress();
    close;
end
