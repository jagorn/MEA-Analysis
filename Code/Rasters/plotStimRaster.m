function plotStimRaster(spikes, repetitions, n_steps_stim, rate, varargin)
% plots a Raster Plot representing the response of ONE cell,
% to several repetitions of A SET of distinct patterns;
%
%
% PARAMETERS:
%
% spikes:           an array representing all the spike times of a given neuron (in time steps).
% repetitions:      a cell array, where each cell corresponds to a stimulus pattern.
%                   each cell contains an array, which containts the first trigger of each repetition.
% n_stes_stim:      the total number of steps in a repetition.
% rate:             the sampling rate of the recording
%
%
% OPTIONAL PARAMETERS:
%
% Title:                the title of the plot.
% Labels:               the labels on the y axis of the plot.
% Pattern_Indices:      the indices of the patterns to plot.
% Pre_Stim_DT:          include in the raster this interval of time (seconds) before the stimulus onset.
% Post_Stim_DT:         include in the raster this interval of time (seconds) after the stimulus offset.
% Point_Size:           size of the raster points.
% Line_Spacing:         blank space left between patterns in the plot.
% Raster_Colors:        the colors to use in the plot to represent each pattern.
% Stim_Color:           the color to use in the plot to represent the stimulus.
% Dead_Times:           the dead_times used during the spike-sorting for each pattern.
% Edges_onsets:         list of times (seconds) at which to draw some vertical edges
% Edges_offsets:        list of times (seconds) at which to draw some vertical edges
% Edges_colors:         list of colors for the vertical edges
% N_Max_Repetitions:    maximum number of repetitions shown for each pattern.


n_patterns = numel(repetitions);

% Default Parameters
title_default = 'Stim Raster Plot';
labels_default = 1:n_patterns;
pattern_indices_default = 1:n_patterns;
pre_stim_dt_default = 0.2;
post_stim_dt_default = 0.2;
size_points_default = 15;
line_spacing_default = 3;
patterns_colors_default = getColors(n_patterns);
stim_color_default = [.85 .9 .85];
dead_times_default = {};
edges_onset_default = [];
edges_offset_default = [];
edges_color_default = [];
n_max_reps_default = 0;

% Parse Input
p = inputParser;
addRequired(p, 'spikes');
addRequired(p, 'repetitions');
addRequired(p, 'n_steps_stim');
addRequired(p, 'rate');

addParameter(p, 'Title', title_default);
addParameter(p, 'Labels', labels_default);
addParameter(p, 'Pattern_Indices', pattern_indices_default);
addParameter(p, 'Pre_Stim_DT', post_stim_dt_default);
addParameter(p, 'Post_Stim_DT', pre_stim_dt_default);
addParameter(p, 'Point_Size', size_points_default);
addParameter(p, 'Line_Spacing', line_spacing_default);
addParameter(p, 'Raster_Colors', patterns_colors_default);
addParameter(p, 'Stim_Color', stim_color_default);
addParameter(p, 'Dead_Times', dead_times_default);
addParameter(p, 'Edges_Onsets', edges_offset_default);
addParameter(p, 'Edges_Offsets', edges_onset_default);
addParameter(p, 'Edges_Colors', edges_color_default);
addParameter(p, 'N_Max_Repetitions', n_max_reps_default);

parse(p, spikes, repetitions, n_steps_stim, rate, varargin{:});


title_txt = p.Results.Title; 
labels = p.Results.Labels; 
pattern_idx = p.Results.Pattern_Indices; 
pre_stim_dt = p.Results.Pre_Stim_DT; 
post_stim_dt = p.Results.Post_Stim_DT; 
point_size = p.Results.Point_Size; 
line_spacing = p.Results.Line_Spacing; 
raster_colors = p.Results.Raster_Colors; 
stim_color = p.Results.Stim_Color; 
dead_times = p.Results.Dead_Times; 
edges_onsets = p.Results.Edges_Onsets; 
edges_offsets = p.Results.Edges_Offsets; 
edges_colors = p.Results.Edges_Colors; 
n_max_repetitions = p.Results.N_Max_Repetitions; 


pre_stim_steps = pre_stim_dt*rate;
post_stim_steps = post_stim_dt*rate;

n_steps_resp =  n_steps_stim + pre_stim_steps + post_stim_dt;

stim_duration = n_steps_stim / rate;
response_duration = n_steps_resp / rate;

for reps = repetitions
    n_max_repetitions = max(n_max_repetitions, numel(reps{:}));
end
n_tot_repetitions = numel(pattern_idx) * (n_max_repetitions + line_spacing);

xlim([min(0, -pre_stim_dt), max(stim_duration, response_duration - pre_stim_dt + post_stim_dt)])
ylim([-line_spacing, n_tot_repetitions])


hold on
set(gca,'ytick',[])
xlabel("Spike Times (s)")
ylabel("Patterns")

% add a stripe o spike trains for each pattern
i_row = 0;
y_ticks = [];

for i_pattern = pattern_idx
    rs_init = repetitions{i_pattern};
    rs_end = repetitions{i_pattern} + n_steps_stim;
    color = raster_colors(i_pattern, :);
    
    rect_edges = [0, i_row-1, n_steps_stim/rate, n_max_repetitions+1];
    rectangle('Position', rect_edges, 'FaceColor', stim_color, 'EdgeColor', 'none')
    
    if ~isempty(dead_times)
        for i_dt = 1:numel(dead_times{i_pattern}.begin)
            dt_begin = dead_times{i_pattern}.begin(i_dt)/rate;
            dt_end = dead_times{i_pattern}.end(i_dt)/rate;

            rect_edges = [dt_begin, i_row-1, dt_end - dt_begin, n_max_repetitions+1];
            rectangle('Position', rect_edges, 'FaceColor', 'k', 'EdgeColor', 'none')
        end
    end
    
    for r = 1:n_max_repetitions
        i_row = i_row + 1;
        
        if r <= numel(repetitions{i_pattern})
            spikes_segment = and(spikes > rs_init(r) + pre_stim_steps, spikes < rs_end(r) + post_stim_steps);
            spikes_rep = spikes(spikes_segment) - rs_init(r);
            spikes_rep = spikes_rep(:).';
            y_spikes_rep = ones(1, length(spikes_rep)) * i_row;
            scatter(spikes_rep / rate, y_spikes_rep, point_size, color, 'Filled', 'o')
        end
    end  
    y_ticks = [y_ticks, i_row - n_max_repetitions/2];  
    i_row = i_row + line_spacing;
end
yticks(y_ticks)
yticklabels(labels);
title(title_txt, 'Interpreter', 'None')

% add edges
if empty(edges_colors)
    edges_colors = getColors(max(numel(edges_onsets), numel(edges_offsets)));
end
    
for i_onset = 1:numel(edges_onsets)
    xline(edges_onsets(i_onset), 'LineWidth', 1.5, 'Color', edges_colors(i_onset, :));
end

for i_offset = 1:numel(edges_offsets)
    xline(edges_offsets(i_offset), 'LineWidth', 1.5, 'Color', edges_colors(i_offset, :));
end
