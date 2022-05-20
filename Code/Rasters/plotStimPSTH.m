% raster for one cell, responding to several repetitions of distinct patterns
function plotStimPSTH(psths, tbin, varargin)

[n_patterns, n_bins] = size(psths);

% Default Parameters
offset_default = 0;
onset_default = 0;
labels_default = [];
dead_times_default = {};
pattern_indices_default = [];
sampling_rate_default = [];  
psth_max_default = 80;

size_line_default = 1.5;
rect_color_default = [.7, .7, .7, 0.5];
colors_default = [];
title_default = 'Stim Raster Plot';

edges_onset_default = [];
edges_offset_default = [];
edges_color_default = [];

% Parse Input
p = inputParser;
addRequired(p, 'psths');
addRequired(p, 'tbin');
addParameter(p, 'Stim_Offset_Seconds', offset_default);
addParameter(p, 'Stim_Onset_Seconds', onset_default);
addParameter(p, 'Labels', labels_default);
addParameter(p, 'Dead_Times', dead_times_default);
addParameter(p, 'Dead_Times_Rate', sampling_rate_default);
addParameter(p, 'Pattern_Indices', pattern_indices_default);
addParameter(p, 'Line_Size', size_line_default);
addParameter(p, 'Stim_Color', rect_color_default);
addParameter(p, 'PSTH_Colors', colors_default);
addParameter(p, 'PSTH_max', psth_max_default);
addParameter(p, 'Title', title_default);
addParameter(p, 'Column_Size', []);
addParameter(p, 'Edges_Onsets', edges_offset_default);
addParameter(p, 'Edges_Offsets', edges_onset_default);
addParameter(p, 'Edges_Colors', edges_color_default);

parse(p, psths, tbin, varargin{:});

onset_seconds = p.Results.Stim_Onset_Seconds; 
offset_seconds = p.Results.Stim_Offset_Seconds; 
labels = p.Results.Labels; 
dead_times = p.Results.Dead_Times; 
dt_rate = p.Results.Dead_Times_Rate; 
pattern_idx = p.Results.Pattern_Indices; 
line_size = p.Results.Line_Size; 
stim_color = p.Results.Stim_Color; 
psth_colors = p.Results.PSTH_Colors; 
column_size = p.Results.Column_Size; 
psth_max = p.Results.PSTH_max; 
title_txt = p.Results.Title; 

psth_tickness = 10;
line_spacing = 3;

edges_onsets = p.Results.Edges_Onsets; 
edges_offsets = p.Results.Edges_Offsets; 
edges_colors = p.Results.Edges_Colors; 

if isempty(pattern_idx)
    pattern_idx = 1:n_patterns;
end

if isempty(psth_colors)
    psth_colors = getColors(n_patterns);
end

if isempty(column_size)
    column_size = numel(pattern_idx);
end

if isempty(labels)
    labels = pattern_idx;
end

psth_dt = n_bins*tbin;
x_psth = linspace(0, psth_dt, n_bins);
plot_height = column_size * (psth_tickness + line_spacing);
stim_dt = psth_dt - onset_seconds + offset_seconds;

% build figure with background rectangle representing the stimulus
xlim([min(0, onset_seconds), max(stim_dt, psth_dt)])
ylim([-line_spacing, plot_height])

hold on
set(gca,'ytick',[])
xlabel("Spike Times (s)")
ylabel("Patterns")


% add a stripe o spike trains for each pattern
i_row = 0;
y_ticks = [];

for i_pattern = pattern_idx(:)'

    color = psth_colors(i_pattern, :);    
    rect_edges = [onset_seconds, i_row, stim_dt, psth_tickness+1];
    rectangle('Position', rect_edges, 'FaceColor', stim_color, 'EdgeColor', 'none')
    
    if ~isempty(dead_times)
        for i_dt = 1:numel(dead_times{i_pattern}.begin)
            dt_begin = dead_times{i_pattern}.begin(i_dt)/dt_rate;
            dt_end = dead_times{i_pattern}.end(i_dt)/dt_rate;

            rect_edges = [- offset_seconds + dt_begin, i_row, dt_end - dt_begin, psth_tickness+1];
            rectangle('Position', rect_edges, 'FaceColor', 'k', 'EdgeColor', 'k')
        end
    end
    
    norm_psth = psths(i_pattern, :)/psth_max * psth_tickness  + i_row;
    
    
    base = ones(size(norm_psth)) * i_row;
    x_between = [x_psth, fliplr(x_psth)];
    in_between = [norm_psth, fliplr(base)];
    fill(x_between, in_between, color, 'EdgeColor', color);
    
    %     plot(x_psth, norm_psth, 'Color', color, 'LineWidth', line_size);
    
    y_ticks = [y_ticks, i_row + psth_tickness/2];  
    i_row = i_row + line_spacing + psth_tickness;
end
yticks(y_ticks)
yticklabels(labels);
set(gca,'TickLabelInterpreter','none')
title(title_txt, 'Interpreter', 'None')



% add edges
if isempty(edges_colors)
    edges_colors = getColors(max(numel(edges_onsets), numel(edges_offsets)));
end
    
for i_onset = 1:numel(edges_onsets)
    xline(edges_onsets(i_onset), 'LineWidth', line_size, 'Color', edges_colors(i_onset, :));
end

for i_offset = 1:numel(edges_offsets)
    xline(edges_offsets(i_offset), 'LineWidth', line_size, 'Color', edges_colors(i_offset, :));
end
