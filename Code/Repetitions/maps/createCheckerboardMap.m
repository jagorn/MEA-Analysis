function createCheckerboardMap()
% Creates the repetition map for the checkerboard stimululs.
% The repetition map is saved in the stimuli folder.

% repetitions_map: a cell array describing the structure of the stimulus.
%   repetitions_map.stim_duration: the whole duration (in frames) of the stimulus
%   repetitions_map.names{i}: the name of the i-th repeated patterns of the stimulus
%   repetitions_map.start_indexes{i}: an array representing the indexes of the starting frame of the i-th repeated pattern
%   repetitions_map.durations{i}: the duration (in frames) of the i-th repeated pattern


block_size = 600;
checker_version = 'checkerboard';
stim_duration = (block_size * 120);

rep_begin = (block_size + 1) : (block_size * 2) : stim_duration;

repetitions_map.names{1} = 'checkerboard';
repetitions_map.start_indexes{1} = rep_begin;
repetitions_map.durations{1} = block_size;
repetitions_map.stim_duration = stim_duration;

stim_file = fullfile(stimPath('checkerboard'), strcat(lower(checker_version), '.mat'));
save(stim_file, 'repetitions_map');

