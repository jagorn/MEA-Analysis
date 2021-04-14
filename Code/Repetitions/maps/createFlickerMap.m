function createFlickerMap()
% Creates the repetition map for the flicker stimululs.
% The repetition map is saved in the stimuli folder.

% repetitions_map: a cell array describing the structure of the stimulus.
%   repetitions_map.stim_duration: the whole duration (in frames) of the stimulus
%   repetitions_map.names{i}: the name of the i-th repeated patterns of the stimulus
%   repetitions_map.start_indexes{i}: an array representing the indexes of the starting frame of the i-th repeated pattern
%   repetitions_map.durations{i}: the duration (in frames) of the i-th repeated pattern

% white first version
flicker_version = 'flicker_white_first';

stim_duration = 30;
rep_begin_white = 1 : 2 : stim_duration;
rep_begin_black = 2 : 2 : stim_duration;


repetitions_map.names{1} = 'flickerOn';
repetitions_map.names{2} = 'flickerOff';
repetitions_map.names{3} = 'flicker';

repetitions_map.start_indexes{1} = rep_begin_white;
repetitions_map.start_indexes{2} = rep_begin_black;
repetitions_map.start_indexes{3} = rep_begin_white;

repetitions_map.durations{1} = 1;
repetitions_map.durations{2} = 1;
repetitions_map.durations{3} = 2;

repetitions_map.stim_duration = stim_duration;

stim_file = fullfile(stimPath('flicker'), strcat(lower(flicker_version), '.mat'));
save(stim_file, 'repetitions_map');


clear


% black first version
flicker_version = 'flicker_black_first';

stim_duration = 30;
rep_begin_white = 2 : 2 : stim_duration;
rep_begin_black = 1 : 2 : stim_duration;


repetitions_map.names{1} = 'flickerOn';
repetitions_map.names{2} = 'flickerOff';
repetitions_map.names{3} = 'flicker';

repetitions_map.start_indexes{1} = rep_begin_white;
repetitions_map.start_indexes{2} = rep_begin_black;
repetitions_map.start_indexes{3} = rep_begin_white;

repetitions_map.durations{1} = 1;
repetitions_map.durations{2} = 1;
repetitions_map.durations{3} = 2;

repetitions_map.stim_duration = stim_duration;

stim_file = fullfile(stimPath('flicker'), strcat(lower(flicker_version), '.mat'));
save(stim_file, 'repetitions_map');