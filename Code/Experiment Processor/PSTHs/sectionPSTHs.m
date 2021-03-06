function psth = sectionPSTHs(spike_times, repetitions, mea_rate, varargin)

% Parse Input
p = inputParser;
addRequired(p, 'spike_times');
addRequired(p, 'repetitions');
addRequired(p, 'mea_rate');
addParameter(p, 'Time_Bin', 0.05);
addParameter(p, 'Time_Spacing', 00);
addParameter(p, 'Smoothing_Coeff', 0.1);
addParameter(p, 'Cell_Indices', 1:(min(numel(spike_times), 10)));

parse(p, spike_times, repetitions, mea_rate, varargin{:});
t_bin = p.Results.Time_Bin;
t_spacing = p.Results.Time_Spacing;
smoothing = p.Results.Smoothing_Coeff;
cell_idx = p.Results.Cell_Indices;

psth.t_bin = t_bin;
psth.patterns = repetitions.names;
   
n_patterns = numel(repetitions.names);
for i_pattern = 1:n_patterns
    
    n_steps = repetitions.durations{i_pattern};
    rep_begin = repetitions.rep_begins{i_pattern};
    n_bins = round(n_steps / (t_bin*mea_rate));
    
    [ypsth, xpsth, ~, ~] = doSmoothPSTH(spike_times, rep_begin, t_bin*mea_rate, n_bins, mea_rate, cell_idx, smoothing);
    psth.responses{i_pattern} = ypsth;
    psth.time_sequences{i_pattern} = xpsth;
end

