function createEulerMap()

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

