function plotSectionRasterMEA(exp_id, section_id, pattern_id)
% show a multi-unit raster plot for an MEA on a particular repeated pattern.
%
% PARAMS:
% EXP_ID:           identifier of the experiment.
% SECTION_ID:       identifier of the section.
% PATTERN:          identifier of the repeated pattern

spike_times = getMua(exp_id);
[evt_timesteps, evt_binsize] = getRepetitionsPattern(exp_id, section_id, pattern_id);
mea_rate = getMeaRate(exp_id);
mea_map = getMeaPositions(exp_id);

plotRasterMEA(spike_times, evt_timesteps, evt_binsize, 0, mea_rate, mea_map)
title_text = strcat("exp ", exp_id, ": ", section_id, "-", pattern_id, ", multi-unit responses");
title(title_text);

