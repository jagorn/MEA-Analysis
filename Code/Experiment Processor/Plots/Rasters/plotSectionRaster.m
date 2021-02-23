function plotSectionRaster(exp_id, section_id, pattern_id)
% show a raster plot of sorted cells on a particular repeated pattern.
%
% PARAMS:
% EXP_ID:           identifier of the experiment.
% SECTION_ID:       identifier of the section.
% PATTERN:          identifier of the repeated pattern

rate = getMeaRate(exp_id);
spike_times = getSpikeTimes(exp_id);
[repetitions, n_steps_stim] = getRepetitionsPattern(exp_id, section_id, pattern_id);

n_cells_in_panel = 20;
n_cells = numel(spike_times);
n_panels = n_cells / n_cells_in_panel;

for i_panel = 1:n_panels
    figure();
    title_text = strcat("exp ", exp_id, ": ", section_id, "-", pattern_id, ", panel#", num2str(i_panel));
    cells_idx = (1:n_cells_in_panel) + ((i_panel-1) * n_cells_in_panel);
    plotCellsRaster(spike_times, repetitions, n_steps_stim, rate, ...
                    'Cells_Indices', cells_idx, ...
                    'Title', title_text)   
end
