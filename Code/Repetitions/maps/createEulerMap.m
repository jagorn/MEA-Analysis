function createEulerMap()
% Creates the repetition map for the euler stimululs.
% The repetition map is saved in the stimuli folder.

% repetitions_map: a cell array describing the structure of the stimulus.
%   repetitions_map.stim_duration: the whole duration (in frames) of the stimulus
%   repetitions_map.names{i}: the name of the i-th repeated patterns of the stimulus
%   repetitions_map.start_indexes{i}: an array representing the indexes of the starting frame of the i-th repeated pattern
%   repetitions_map.durations{i}: the duration (in frames) of the i-th repeated pattern


euler_version = 'euler_180530';
euler_length = 999;
stim_duration = euler_length * 30;
rep_begin = 1 : euler_length : stim_duration;


repetitions_map.names{1} = 'euler';
repetitions_map.start_indexes{1} = rep_begin;
repetitions_map.durations{1} = euler_length;
repetitions_map.stim_duration = stim_duration;

stim_file = fullfile(stimPath('euler'), strcat(lower(euler_version), '.mat'));
save(stim_file, 'repetitions_map');



euler_version = 'euler_rev';
euler_length = 1919;
stim_duration = euler_length * 4;
rep_begin = 1 : euler_length : stim_duration;


repetitions_map.names{1} = 'euler_rev';
repetitions_map.start_indexes{1} = rep_begin;
repetitions_map.durations{1} = euler_length;
repetitions_map.stim_duration = stim_duration;

stim_file = fullfile(stimPath('euler'), strcat(lower(euler_version), '.mat'));
save(stim_file, 'repetitions_map');