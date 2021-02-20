% Creates the repetition map for the flicker stimululs.
% The repetition map is saved in the stimuli folder.

% repetitions_map: a cell array describing the structure of the stimulus.
%   repetitions_map.stim_duration: the whole duration (in frames) of the stimulus
%   repetitions_map.names{i}: the name of the i-th repeated patterns of the stimulus
%   repetitions_map.start_indexes{i}: an array representing the indexes of the starting frame of the i-th repeated pattern
%   repetitions_map.durations{i}: the duration (in frames) of the i-th repeated pattern

% This stimulus consists of a fullfield set of flashes:
% We have 1 second white flashes interleaved with 1 second black flashes.

% Imagine two versions of this stimulus exist:
% - The WHITE_FIRST version, that starts with a white flash.
% - The BLACK_FIRST version, that starts with a black flash.


% WHITE_FIRST version

% we choose a name for the stimulus 
flicker_version = 'flicker_white_first';

% The stim is composed by 30 frames.
stim_duration = 30;

% The odd frames correspond to white flashes
rep_begin_white = 1 : 2 : stim_duration;

% The black frames correspond to black flashes
rep_begin_black = 2 : 2 : stim_duration;


% We create the repetitions_map object.
% There are two repeated patterns: the black flashes and the white flashes.

% We include:
% The name of the repeated patterns.
repetitions_map.names{1} = 'white';
repetitions_map.names{2} = 'black';

% The indexes of the first event marker for each pattern. 
% (which is, the starting frame of each the repetitions)
repetitions_map.start_indexes{1} = rep_begin_white;
repetitions_map.start_indexes{2} = rep_begin_black;

% The duration (in frames) of each repetition.
repetitions_map.durations{1} = 1;
repetitions_map.durations{2} = 1;

% The duration of the whole stimulus
repetitions_map.stim_duration = stim_duration;

% We then save everything in the Stimuli folder, in a subfolder called 'flicker'
stim_file = fullfile(stimPath('flicker'), strcat(lower(flicker_version), '.mat'));
save(stim_file, 'repetitions_map');


clear


% We repeat the same procedure for the other version of the stimulus:
flicker_version = 'flicker_black_first';

stim_duration = 30;
rep_begin_white = 2 : 2 : stim_duration;
rep_begin_black = 1 : 2 : stim_duration;


repetitions_map.names{1} = 'white';
repetitions_map.names{2} = 'black';

repetitions_map.start_indexes{1} = rep_begin_white;
repetitions_map.start_indexes{2} = rep_begin_black;

repetitions_map.durations{1} = 1;
repetitions_map.durations{2} = 1;

repetitions_map.stim_duration = stim_duration;

stim_file = fullfile(stimPath('flicker'), strcat(lower(flicker_version), '.mat'));
save(stim_file, 'repetitions_map');