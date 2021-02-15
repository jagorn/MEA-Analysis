function createFlickerMap()

% white first version
flicker_version = 'flicker_white_first';

stim_duration = 30;
rep_begin_white = 1 : 2 : stim_duration;
rep_begin_black = 2 : 2 : stim_duration;


repetitions_map.names{1} = 'white';
repetitions_map.names{2} = 'black';

repetitions_map.start_indexes{1} = rep_begin_white;
repetitions_map.start_indexes{2} = rep_begin_black;

repetitions_map.durations{1} = 1;
repetitions_map.durations{2} = 1;

repetitions_map.stim_duration = stim_duration;

stim_file = fullfile(stimPath('flicker'), strcat(lower(flicker_version), '.mat'));
save(stim_file, 'repetitions_map');


clear


% black first version
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