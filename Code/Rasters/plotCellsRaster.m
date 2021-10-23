function plotCellsRaster(spikes, repetitions, n_steps_stim, rate, varargin)
% plots a Raster Plot representing the response of several cells,
% to the repetitions of a given stimulus pattern;
%
%
% PARAMETERS:
%
% spikes:           a cell array, where each cell corresponds to a neuron.
%                   each cell contains an array, which represents all the spike times of the neuron (in time steps).
% repetitions:      an array which containts the first trigger of each repetition.
% n_stes_stim:      the total number of steps in a repetition.
% rate:             the sampling rate of the recording
%
%
% OPTIONAL PARAMETERS:
%
% Title:                the title of the plot.
% Labels:               the labels on the y axis of the plot.
% Cells_Indices:         the indices of the cells to plot.
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


n_cells = numel(spikes);

% Default Parameters
title_default = 'Cells Raster Plot';
labels_default = [];
cells_indices_default = 1:n_cells;
pre_stim_dt_default = 0.5;
post_stim_dt_default = 0.5;
size_points_default = 5;
line_spacing_default = 3;
cells_colors_default = getColors(n_cells);
stim_color_default = [.7, .7, .7, 0.5];
dead_times_default = {};
edges_onset_default = [];
edges_offset_default = [];
edges_color_default = [];
max_reps_default = 20;

% Parse Input
p = inputParser;
addRequired(p, 'spikes');
addRequired(p, 'repetitions');
addRequired(p, 'n_steps_stim');
addRequired(p, 'rate');

addParameter(p, 'Title', title_default);
addParameter(p, 'Labels', labels_default);
addParameter(p, 'Cells_Indices', cells_indices_default);
addParameter(p, 'Column_Size', []);
addParameter(p, 'Pre_Stim_DT', post_stim_dt_default);
addParameter(p, 'Post_Stim_DT', pre_stim_dt_default);
addParameter(p, 'Point_Size', size_points_default);
addParameter(p, 'Line_Spacing', line_spacing_default);
addParameter(p, 'Raster_Colors', cells_colors_default);
addParameter(p, 'Stim_Color', stim_color_default);
addParameter(p, 'Dead_Times', dead_times_default);
addParameter(p, 'Edges_Onsets', edges_offset_default);
addParameter(p, 'Edges_Offsets', edges_onset_default);
addParameter(p, 'Edges_Colors', edges_color_default);
addParameter(p, 'Max_Repetitions', max_reps_default);
parse(p, spikes, repetitions, n_steps_stim, rate, varargin{:});

title_txt = p.Results.Title; 
labels = p.Results.Labels; 
cells_idx = p.Results.Cells_Indices; 
column_size = p.Results.Column_Size; 
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
max_reps = p.Results.Max_Repetitions;

if isempty(column_size)
    column_size = numel(cells_idx);
end

pre_stim_steps = pre_stim_dt*rate;
post_stim_steps = post_stim_dt*rate;

n_steps_resp =  n_steps_stim + pre_stim_steps + post_stim_dt;

stim_duration = n_steps_stim / rate;
response_duration = n_steps_resp / rate;

n_repetitions = min(max_reps, numel(repetitions));
n_tot_repetitions = column_size * (n_repetitions + line_spacing);


xlim([min(0, -pre_stim_dt), max(stim_duration, response_duration - pre_stim_dt + post_stim_dt)])
ylim([-line_spacing, n_tot_repetitions])

hold on
set(gca,'ytick',[])
xlabel("Spike Times (s)")
ylabel("Cells")

% add a stripe of spike trains for each pattern
i_row = 0;
y_ticks = [];

rs_init = repetitions;
rs_end = repetitions + n_steps_resp;

for i_cell = cells_idx
    spikes_cell = spikes{i_cell};
    color = raster_colors(i_cell, :);
    rect_edges = [0, i_row-1, n_steps_stim/rate, n_repetitions+1];
    rectangle('Position', rect_edges, 'FaceColor', stim_color, 'EdgeColor', 'none')
    
    if ~isempty(dead_times)
        for i_dt = 1:numel(dead_times.begin)
            dt_begin = dead_times.begin(i_dt)/rate;
            dt_end = dead_times.end(i_dt)/rate;

            rect_edges = [dt_begin, i_row-1, dt_end - dt_begin, n_repetitions+1];
            rectangle('Position', rect_edges, 'FaceColor', 'k', 'EdgeColor', 'none')
        end
    end

    for r = 1:n_repetitions
        
        spikes_segment = and(spikes_cell > rs_init(r) - pre_stim_steps, spikes_cell < rs_end(r) + post_stim_steps);
        spikes_rep = spikes_cell(spikes_segment) - rs_init(r);
        spikes_rep = spikes_rep(:).';
        y_spikes_rep = ones(1, length(spikes_rep)) * i_row;
        scatter(spikes_rep / rate, y_spikes_rep, point_size, color, 'Filled', 'o')
        i_row = i_row + 1;

    end  
    y_ticks = [y_ticks, i_row - n_repetitions/2];  
    i_row = i_row + line_spacing;
end


if isempty(labels)
    labels = cells_idx;
end

yticks(y_ticks)
yticklabels(labels);
title(title_txt, 'Interpreter', 'None')

% add edges
if isempty(edges_colors)
    edges_colors = getColors(max(numel(edges_onsets), numel(edges_offsets)));
end
    
for i_onset = 1:numel(edges_onsets)
    xline(edges_onsets(i_onset), 'LineWidth', 1.5, 'Color', edges_colors(i_onset, :));
end

for i_offset = 1:numel(edges_offsets)
    xline(edges_offsets(i_offset), 'LineWidth', 1.5, 'Color', edges_colors(i_offset, :));
end
