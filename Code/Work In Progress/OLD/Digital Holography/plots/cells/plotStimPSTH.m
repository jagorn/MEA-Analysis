% raster for one cell, responding to several repetitions of distinct patterns

function plotStimPSTH(psths, tbin, varargin)

[n_patterns, n_bins] = size(psths);

% Default Parameters
offset_default = 0;
onset_default = 0;
labels_default = [];
dead_times_default = {};
pattern_indices_default = 1:n_patterns;
sampling_rate_default = [];  
psth_max_default = max(psths(:));

size_line_default = 2;
rect_color_default = [.85 .9 .9];
colors_default = getColors(n_patterns);
title_default = 'Stim Raster Plot';

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

if isempty(column_size)
    column_size = numel(pattern_idx);
end

psth_dt = n_bins*tbin;
x_psth = linspace(0, psth_dt, n_bins);
plot_height = column_size * (psth_tickness + line_spacing);
stim_dt = psth_dt - onset_seconds + offset_seconds;

% build figure with background rectangle representing holo stimulation
xlim([min(0, onset_seconds), max(stim_dt, psth_dt)])
ylim([-line_spacing, plot_height])

hold on
set(gca,'ytick',[])
xlabel("Spike Times (s)")
ylabel("Patterns")

% add a stripe o spike trains for each pattern
i_row = 0;
y_ticks = [];

for i_pattern = pattern_idx

    color = psth_colors(i_pattern, :);    
    rect_edges = [onset_seconds, i_row-1, stim_dt, psth_tickness+1];
    rectangle('Position', rect_edges, 'FaceColor', stim_color, 'EdgeColor', 'none')
    
    if ~isempty(dead_times)
        for i_dt = 1:numel(dead_times{i_pattern}.begin)
            dt_begin = dead_times{i_pattern}.begin(i_dt)/dt_rate;
            dt_end = dead_times{i_pattern}.end(i_dt)/dt_rate;

            rect_edges = [- offset_seconds + dt_begin, i_row-1, dt_end - dt_begin, psth_tickness+1];
            rectangle('Position', rect_edges, 'FaceColor', 'k', 'EdgeColor', 'k')
        end
    end
    
    norm_psth = psths(i_pattern, :)/psth_max * psth_tickness/2;
    plot(x_psth, norm_psth + i_row + psth_tickness/2, 'Color', color, 'LineWidth', line_size);
    
    y_ticks = [y_ticks, i_row + psth_tickness/2];  
    i_row = i_row + line_spacing + psth_tickness;
end
yticks(y_ticks)
yticklabels(labels);
title(title_txt, 'Interpreter', 'None')

% add window
% add window
xline(offset_seconds, 'LineWidth', 1.5, 'Color', 'red');
xline(psth_dt - offset_seconds, 'LineWidth', 1.5, 'Color', 'red');

