function generateStimFile(exp_id, section_id, raw_name)
% It generates the .stim file of an experiment section, necessary to visualize the raster plots in the spiking-circus GUI.


if ~exist('raw_name', 'var')
    raw_name = getSection(exp_id, section_id).id;
end

reps = getRepetitions(exp_id, section_id);

for i = 1:numel(reps)
    rep_begin_time{i} = reps.rep_begins{i};
    rep_end_time{i} = reps.rep_begins{i} + reps.durations{i} - 1;
end

sorting_folder = fullfile(sortedPath(exp_id), raw_name);
if ~isfolder(sorting_folder)
    error_struct.message = strcat("the sorting folder ", sorting_folder, " does not exist.");
    error_struct.identifier = strcat('MEA_Analysis:', mfilename);
    error(error_struct);
end

stim_file = fullfile(sorting_folder, strcat(raw_name, '.stim'));
save(stim_file, 'rep_begin_time', 'rep_end_time');
fprintf('stim file successfully generated.\n')
