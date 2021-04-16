function psth = sectionPSTHs(spike_times, repetitions, mea_rate, varargin)

% Parse Input
p = inputParser;
addRequired(p, 'spike_times');
addRequired(p, 'repetitions');
addRequired(p, 'mea_rate');
addParameter(p, 'Time_Bin', 0.05);
addParameter(p, 'Time_Spacing', 00);
addParameter(p, 'Smoothing_Coeff', 0);
addParameter(p, 'Cell_Indices', 1:numel(spike_times));

parse(p, spike_times, repetitions, mea_rate, varargin{:});
t_bin = p.Results.Time_Bin;
t_spacing = p.Results.Time_Spacing;
smoothing = p.Results.Smoothing_Coeff;
cell_idx = p.Results.Cell_Indices;

psth.t_bin = t_bin;
psth.patterns = repetitions.names;
   
n_patterns = numel(repetitions.names);
for i_pattern = 1:n_patterns
    
    n_steps = repetitions.durations{i_pattern} + 2*t_spacing*mea_rate;
    rep_begin = repetitions.rep_begins{i_pattern} - t_spacing*mea_rate;
    n_bins = round(n_steps / (t_bin*mea_rate));
    
    if smoothing == 0
        [ypsth, xpsth, ~, firing_rates] = doPSTH(spike_times, rep_begin, t_bin*mea_rate, n_bins, mea_rate, cell_idx);
    else
        [ypsth, xpsth, ~, firing_rates] = doSmoothPSTH(spike_times, rep_begin, t_bin*mea_rate, n_bins, mea_rate, cell_idx, smoothing);
    end
    
    psth.responses{i_pattern} = ypsth;
    psth.time_sequences{i_pattern} = xpsth - t_spacing;
    psth.firing_rates{i_pattern} = firing_rates;
end

