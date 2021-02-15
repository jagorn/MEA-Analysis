function repetitions_map = getRepetitionsMap(stim_id, stim_version)
% It returns the repetitions map for a given stimulus.
%
% PARAMTERS:
% STIM_ID:          the identifier of the stimulus.
% STIM_VERSION:     the version of the stimulus.
% 
% OUTPUT:
% repetitions_map: a cell array describing the structure of the stimulus.
%   repetitions_map.stim_duration: the whole duration (in frames) of the stimulus
%   repetitions_map.names{i}: the name of the i-th repeated patterns of the stimulus
%   repetitions_map.start_indexes{i}: an array representing the indexes of the starting frame of the i-th repeated pattern
%   repetitions_map.durations{i}: the duration (in frames) of the i-th repeated pattern

stim_version_file = fullfile(stimPath(stim_id), strcat(stim_version, '.mat'));
load(stim_version_file, 'repetitions_map');

if ~exist('repetitions_map', 'var')
    error_struct.message = strcat("the repetitions map for the stimulus ", stim_id, "(version: ", stim_version, ") has not been found");
    error_struct.identifier = strcat('MEA_Analysis:', mfilename);
    error(error_struct);
end

