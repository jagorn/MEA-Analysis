function repetitions_map = getRepetitionsMap(stim_id, stim_version)
stim_version_file = fullfile(stimPath(stim_id), strcat(stim_version, '.mat'));
load(stim_version_file, 'repetitions_map');

if ~exist('repetitions_map', 'var')
    error_struct.message = strcat("the repetitions map for the stimulus ", stim_id, "(version: ", stim_version, ") has not been found");
    error_struct.identifier = strcat('MEA_Analysis:', mfilename);
    error(error_struct);
end

