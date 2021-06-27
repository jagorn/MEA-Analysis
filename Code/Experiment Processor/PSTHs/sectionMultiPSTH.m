function multi_psth = sectionMultiPSTH(label, spike_times, multi_repetitions, mea_rate, varargin)
% Computes psths to indexable patterns.

% Parse Input
p = inputParser;
addRequired(p, 'spike_times');
addRequired(p, 'repetitions');
addRequired(p, 'mea_rate');
addParameter(p, 'Time_Bin', 0.05);
addParameter(p, 'Time_Spacing', 00);
addParameter(p, 'Smoothing_Coeff', 0);
addParameter(p, 'Include_Firing_rates', false);
addParameter(p, 'Cell_Indices', 1:numel(spike_times));

parse(p, spike_times, multi_repetitions, mea_rate, varargin{:});
t_bin = p.Results.Time_Bin;
t_spacing = p.Results.Time_Spacing;
smoothing = p.Results.Smoothing_Coeff;
include_fr = p.Results.Include_Firing_rates;
cell_idx = p.Results.Cell_Indices;

multi_psth.name = label;
multi_psth.t_bin = t_bin;
multi_psth.t_spacing = t_spacing;
multi_psth.patterns = multi_repetitions.patterns;
multi_psth.set_type = multi_repetitions.set_type;

n_patterns = size(multi_repetitions.patterns, 1);
for i_pattern = 1:n_patterns
    
    n_steps = multi_repetitions.durations(i_pattern) + 2*t_spacing*mea_rate;
    rep_begin = multi_repetitions.rep_begins{i_pattern} - t_spacing*mea_rate;
    n_bins = round(n_steps / (t_bin*mea_rate));
    
    if smoothing == 0
        [ypsth, xpsth, ~, firing_rates] = doPSTH(spike_times, rep_begin, t_bin*mea_rate, n_bins, mea_rate, cell_idx);
    else
        [ypsth, xpsth, ~, firing_rates] = doSmoothPSTH(spike_times, rep_begin, t_bin*mea_rate, n_bins, mea_rate, cell_idx, smoothing);
    end
    
    multi_psth.responses(i_pattern, :, :) = ypsth;
    multi_psth.time_sequences = xpsth - t_spacing;
    
    if include_fr
        multi_psth.firing_rates{i_pattern} = firing_rates;
    end
end