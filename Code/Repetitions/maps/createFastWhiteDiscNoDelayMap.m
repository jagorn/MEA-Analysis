function createFastWhiteDiscNoDelayMap()
% Creates the repetition map for the discdelay stimululs.
% The repetition map is saved in the stimuli folder.

% repetitions_map: a cell array describing the structure of the stimulus.
%   repetitions_map.stim_duration: the whole duration (in frames) of the stimulus
%   repetitions_map.names{i}: the name of the i-th repeated patterns of the stimulus
%   repetitions_map.start_indexes{i}: an array representing the indexes of the starting frame of the i-th repeated pattern
%   repetitions_map.durations{i}: the duration (in frames) of the i-th repeated pattern

stim_name = 'discdelay';
stim_version = 'spots_fast_white_disc_no_delay';
stim_vec = importdata(getVecFile(stim_name, stim_version));

white_state = 1;

visual_sequence = stim_vec(2:end, 2);
holo_sequence = stim_vec(2:end, 4);

rep_begin_white = find(visual_sequence(1:end-1) == 0 &  visual_sequence(2:end) == white_state) + 1;
rep_end_white = find(visual_sequence(1:end-1) == white_state &  visual_sequence(2:end) == 0) + 1;

pure_visual_white = false(1, numel(rep_begin_white));

for i_white = 1:numel(rep_begin_white)
    begin_white = rep_begin_white(i_white);
    end_white = rep_end_white(i_white);
    
    if any(holo_sequence(begin_white:end_white))
        % there is holography here, lets discard it.
        pure_visual_white(i_white) = false;
    else
        % pure visual stim, we keep it
        pure_visual_white(i_white) = true;
    end
end

 
rep_begin_white = rep_begin_white(pure_visual_white);
rep_end_white = rep_end_white(pure_visual_white);

repetitions_map.names{1} = 'white_disc';
repetitions_map.start_indexes{1} = rep_begin_white;
repetitions_map.durations{1} = median(rep_end_white - rep_begin_white);
repetitions_map.stim_duration = numel(visual_sequence);

stim_file = fullfile(stimPath(stim_name), strcat(lower(stim_version), '.mat'));
save(stim_file, 'repetitions_map');

