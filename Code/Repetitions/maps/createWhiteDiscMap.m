function createWhiteDiscMap()
% Creates the repetition map for the discdelay stimululs.
% The repetition map is saved in the stimuli folder.

% repetitions_map: a cell array describing the structure of the stimulus.
%   repetitions_map.stim_duration: the whole duration (in frames) of the stimulus
%   repetitions_map.names{i}: the name of the i-th repeated patterns of the stimulus
%   repetitions_map.start_indexes{i}: an array representing the indexes of the starting frame of the i-th repeated pattern
%   repetitions_map.durations{i}: the duration (in frames) of the i-th repeated pattern

stim_name = 'discdelay';
stim_version = 'white_disc';
stim_file = 'spots_white_disc_no_delay';
stim_vec = importdata(getVecFile(stim_name, stim_file));

white_state = 1;
visual_sequence = stim_vec(2:end, 2);

rep_begin_white = find(visual_sequence(1:end-1) == 0 &  visual_sequence(2:end) == white_state) + 1;
rep_end_white = find(visual_sequence(1:end-1) == white_state &  visual_sequence(2:end) == 0) + 1;

repetitions_map.names{1} = 'white_disc';
repetitions_map.start_indexes{1} = rep_begin_white;
repetitions_map.durations{1} = median(rep_end_white - rep_begin_white);
repetitions_map.stim_duration = numel(visual_sequence);

stim_file = fullfile(stimPath(stim_name), strcat(lower(stim_version), '.mat'));
save(stim_file, 'repetitions_map');

