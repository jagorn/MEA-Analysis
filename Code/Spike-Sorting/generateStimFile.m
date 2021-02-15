function generateStimFile(exp_id, section_id)
% It generates the .stim file of an experiment section, necessary to visualize the raster plots in the spiking-circus GUI.

reps = getRepetitions(exp_id, section_id);

for i = 1:numel(reps)
    rep_begin_time{i} = reps.rep_begins{i};
    rep_end_time{i} = reps.rep_begins{i} + reps.durations{i};

end

stim_file = fullfile(sortedPath(exp_id), strcat(exp_id, '.stim'));
save(stim_file, 'rep_begin_time', 'rep_end_time');
