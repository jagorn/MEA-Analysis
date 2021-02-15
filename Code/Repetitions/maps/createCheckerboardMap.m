function createCheckerboardMap()

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

