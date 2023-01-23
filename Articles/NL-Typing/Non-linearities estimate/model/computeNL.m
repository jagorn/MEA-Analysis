function models = computeNL(spikes, t_filters, stimulus, frame_rate, rep_begin, rep_end, varargin)

% ATTENTION:
% stimulus and temporal filters (t_filters) must be
% resampled at the same frequency frame_rate

% Default Parameters
mea_rate_def = 20000;
cell_idx_def = 1:numel(spikes);
experiment_def = "N/A";
s_filters_def = [];
s_threshold_def = 0.01;
binarize_spikes_def = true;
g_min_def = -1;
g_max_def = 2;
g_step_def = 0.01;

% Parse Input
p = inputParser;
addRequired(p, 'spikes');
addRequired(p, 't_filters');
addRequired(p, 'stimulus');
addRequired(p, 'frame_rate');
addRequired(p, 'rep_begin');
addRequired(p, 'rep_end');
addParameter(p, 'Mea_Rate', mea_rate_def);
addParameter(p, 'Cell_Idx', cell_idx_def);
addParameter(p, 'Experiment', experiment_def);
addParameter(p, 'S_Filters', s_filters_def);
addParameter(p, 'S_Threshold', s_threshold_def);
addParameter(p, 'Binarize_Spikes', binarize_spikes_def);
addParameter(p, 'G_Min', g_min_def);
addParameter(p, 'G_Max', g_max_def);
addParameter(p, 'G_Step', g_step_def);

parse(p, spikes, t_filters, stimulus, frame_rate, rep_begin, rep_end, varargin{:});
mea_rate = p.Results.Mea_Rate;
cell_idx = p.Results.Cell_Idx;
experiment = p.Results.Experiment;
s_filters = p.Results.S_Filters;
s_threshold = p.Results.S_Threshold;
binarize_spikes = p.Results.Binarize_Spikes;
g_min = p.Results.G_Min;
g_max = p.Results.G_Max;
g_step = p.Results.G_Step;

% Compute Variables
n_all_cells = numel(spikes);
n_idx_cells = numel(cell_idx);
n_reps = numel(rep_begin);

% Standardize stimulus to 3D format
if isvector(stimulus)
    n_stim_rows = 1;
    n_stim_cols = 1;
    n_stim_steps = numel(stimulus);
    
    stimulus_3d(1, 1, :) = stimulus;
    stimulus = stimulus_3d;
    
elseif ismatrix(stimulus)
    
    n_stim_rows = 1;
    [n_stim_cols, n_stim_steps] = size(stimulus);
    
    stimulus_3d(1, :, :) = stimulus;
    stimulus = stimulus_3d;
    
elseif ndims(stimulus) == 3
    [n_stim_rows, n_stim_cols, n_stim_steps] = size(stimulus);
else
    error('stimulus cannot be 4+ dimensional (or 1- dimensional)');
end

% Compute PSTh (Only for plots and debug)
bin_size = round(1/frame_rate * mea_rate);
[psths, x_psth, ~, ~] = doSmoothPSTH(spikes, rep_begin, bin_size, n_stim_steps,  mea_rate, cell_idx, 2/frame_rate);

% Initialize spatial filters
if isempty(s_filters)
    s_filters = ones(n_all_cells, n_stim_rows, n_stim_cols);
end

% Compute NLs
models(n_idx_cells) = struct();

for i_cell = 1:n_idx_cells
    
    cell_id = cell_idx(i_cell);
    spike_train = spikes{cell_id};
    t_filter = squeeze(t_filters(cell_id, :));
    s_filter = squeeze(s_filters(cell_id, :, :));
    
    % Normalize Temporal Filters
    t_filter = t_filter - 0.5;
    t_filter = t_filter / max(abs(t_filter));
    n_t_filter = length(t_filter);
    
    % Normalize Spatial Filters
    s_filter(abs(s_filter) < s_threshold) = 0;
    s_filter = s_filter / sum(s_filter(:));
    
    % Filter Stimulus over Space
    s =  squeeze(sum(stimulus .* s_filter, [1 2]));
    
    % Convolute Stimulus over Time
    g = zeros(1, n_stim_steps);
    for i_t = 1:n_stim_steps
        g(i_t) = 0;
        for j_t = 1:min(n_t_filter, i_t)
            g(i_t) = g(i_t) + s(i_t - j_t + 1) * t_filter(end - j_t + 1);
        end
    end
    
    % We compute the non-linearity from Bayes rule as:
    % p(spike | g) = p(g | spike) * p(spike)  / p(g)
    
    
    % Build p(g | spike) over trials looking at the value of g during spikes.
    g_when_spikes = [];
    
    for i_t = 1:n_reps
        spikes_repetition = spike_train(spike_train >= rep_begin(i_t) & spike_train <= rep_end(i_t)) - rep_begin(i_t);
        spikes_indices = ceil(spikes_repetition / mea_rate * frame_rate);
        spikes_indices(spikes_indices == 0) = [];
        
        if binarize_spikes
            spikes_indices = unique(spikes_indices);
        end
        g_when_spikes = [g_when_spikes  g(spikes_indices)];
    end
    
    % Define the NL domain
    edges_nl = linspace(g_min, g_max, 20);
    x_nl = edges_nl(2:end);
    
    % Build the distributions
    p_spike = length(g_when_spikes) / (length(g) * n_reps);
    p_g = histcounts(g, edges_nl) / length(g);
    p_g_given_spike = histcounts(g_when_spikes, edges_nl) / length(g_when_spikes);
    
    % Estimate the non-linearity using Bayes rule
    nl = p_spike * p_g_given_spike ./ p_g;
    
    % Keep only defined values.
    nl_defined_idx = ~isnan(nl);
    nl_x = x_nl(nl_defined_idx);
    nl_y = nl(nl_defined_idx);
    
    try
        % Interpolate intermediate values
        d_min = min(nl_x);
        d_max = max(nl_x);
        d_step = g_step;
        
        nl_x_extended = d_min : d_step : d_max;
        nl_y_extended = interp1(nl_x, nl_y, nl_x_extended, 'spline');
        
        % Apply non-linearity
        g_discretized = g;
        g_discretized(g_discretized <= d_min) = d_min + 1e-5;
        g_discretized(g_discretized > d_max) = d_max;
        g_discretized = (g_discretized - d_min) / d_step;
        g_discretized = ceil(g_discretized);
        
        r = nl_y_extended(g_discretized);
    catch
        fprintf("This nonlinearity could not be computed: exp: %s, cell %i\n", experiment, i_cell);
        models(i_cell).experiment = experiment;
        models(i_cell).n = cell_id;
        
        models(i_cell).experiment = experiment;
        models(i_cell).n = cell_id;
        continue;
    end
    
    % Put everything in a struct
    models(i_cell).experiment = experiment;
    models(i_cell).n = cell_id;
    
    models(i_cell).s_filter = s_filter;
    models(i_cell).t_filter = t_filter;
    models(i_cell).nl_x = nl_x;
    models(i_cell).nl_y = nl_y;
    models(i_cell).nl_x_extended = nl_x_extended;
    models(i_cell).nl_y_extended = nl_y_extended;
    models(i_cell).nl_x_undef = x_nl;
    models(i_cell).nl_y_undef = nl;
    
    models(i_cell).p_spike = p_spike;
    models(i_cell).p_g = p_g;
    models(i_cell).p_g_given_spike = p_g_given_spike;
    models(i_cell).p_edges = edges_nl;
    
    models(i_cell).s = s;
    models(i_cell).g = g;
    models(i_cell).r = r;
    
    models(i_cell).psth = psths(i_cell, :);
    models(i_cell).x = x_psth;
end
