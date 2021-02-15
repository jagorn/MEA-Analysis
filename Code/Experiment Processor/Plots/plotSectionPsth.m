function plotSectionPsth(exp_id, section_id, varargin)

repetitions = getRepetitions(exp_id, section_id);
spike_times = getSpikeTimes(exp_id);
mea_rate = getMeaRate(exp_id);

% Parse Input
p = inputParser;
addRequired(p, 'exp_id');
addRequired(p, 'section_id');
addParameter(p, 'CellIndices', 1:(min(numel(spike_times), 10)));
addParameter(p, 'Pattern_Name', []);
addParameter(p, 'TimeBin', 0.05);
addParameter(p, 'Smoothing_Coeff', 0.1);

parse(p, exp_id, section_id, varargin{:});

cell_idx = p.Results.CellIndices;
pattern_name = p.Results.Pattern_Name;
t_bin = p.Results.TimeBin;
smoothing = p.Results.Smoothing_Coeff;

if isempty(pattern_name)
    i_pattern = 1;
    title_plot = strcat(exp_id, ': ', section_id);

else
    i_pattern = find([repetitions.names] == pattern_name);
    title_plot = strcat(exp_id, ': ', section_id, '-', pattern_name);

    if numel(i_pattern) ~= 1
        error_struct.message = strcat("section ",  num2str(section_id), ": pattern ", pattern_name, " not found in experiment ", exp_id);
        error_struct.identifier = strcat('MEA_Analysis:', mfilename);
        error(error_struct);
    end
end

n_steps = repetitions.durations{i_pattern};
rep_begin = repetitions.rep_begins{i_pattern};

figure();

subplot(1, 2, 1);
plotCellsRaster(spike_times, rep_begin, n_steps, mea_rate, 'Cells_Indices', cell_idx);

subplot(1, 2, 2);
n_bins = round(n_steps / (t_bin*mea_rate));
[psth, xpsth, ~, ~] = doSmoothPSTH(spike_times, rep_begin, t_bin*mea_rate, n_bins, mea_rate, cell_idx, smoothing);
plot(xpsth, psth)
xlabel("Time (s)")
ylabel("Firing Rate (Hz)")

suptitle(title_plot)