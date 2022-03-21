function plotSectionPsth(exp_id, section_id, varargin)
% plots the PSTHs of a group of cells of the experiment exp_id to the
% stimulus played in section_id

% PARAMETERS:
% EXP_ID:                   the identifier of the experiment
% SECTION_ID:               the identifier of the section
% CELL_INDICES (OPTIONAL):  the indices of the cells to plot.
% PATTERN_NAME (OPTIONAL):  the repated pattern of section_id respect to which are computed the PSTHs
% TIME_BIN (OPTIONAL):      the time bin of the psths (default = 50ms)
% SMOOTHING_COEFF:          coefficient of smoothing when computing the psth


repetitions = getRepetitions(exp_id, section_id);
spike_times = getSpikeTimes(exp_id);
mea_rate = getMeaRate(exp_id);

% Parse Input
p = inputParser;
addRequired(p, 'exp_id');
addRequired(p, 'section_id');
addParameter(p, 'Cell_Indices', 1:(min(numel(spike_times), 10)));
addParameter(p, 'Pattern_Name', []);
addParameter(p, 'Time_Bin', 0.05);
addParameter(p, 'Smoothing_Coeff', 0.1);

parse(p, exp_id, section_id, varargin{:});

cell_idx = p.Results.Cell_Indices;
pattern_name = p.Results.Pattern_Name;
t_bin = p.Results.Time_Bin;
smoothing = p.Results.Smoothing_Coeff;

if isempty(pattern_name)
    i_pattern = 1;
    pattern_name = repetitions.names{i_pattern};
else
    i_pattern = find(strcmp(repetitions.names, pattern_name));

    if numel(i_pattern) ~= 1
        error_struct.message = strcat("section ",  num2str(section_id), ": pattern ", pattern_name, " not found in experiment ", exp_id);
        error_struct.identifier = strcat('MEA_Analysis:', mfilename);
        error(error_struct);
    end
end

n_steps = repetitions.durations{i_pattern};
rep_begin = repetitions.rep_begins{i_pattern};

figure();
colors = getColors(numel(spike_times));

subplot(1, 2, 1);
plotCellsRaster(spike_times, rep_begin, n_steps, mea_rate, 'Cells_Indices', cell_idx, 'Raster_Colors', colors);

subplot(1, 2, 2);
n_bins = round(n_steps / (t_bin*mea_rate));
[psth, xpsth, ~, ~] = doSmoothPSTH(spike_times, rep_begin, t_bin*mea_rate, n_bins, mea_rate, cell_idx, smoothing);
hold on
for i = 1:size(psth, 1)
    plot(xpsth, psth(i, :), 'Color', colors(cell_idx(i), :))
end
xlabel("Time (s)")
ylabel("Firing Rate (Hz)")


title_plot = strcat(exp_id, ": ", num2str(section_id), " - ", pattern_name);
h = suptitle(title_plot);
h.Interpreter = 'None';