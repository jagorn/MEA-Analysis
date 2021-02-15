function repetitions = computeRepetitions(triggers, repetitions_map, is_looping)
% here we compute the repetitions of all the patterns in a given stimulus
%
% PARAMETERS:
% triggers: the event markers of the stimulus recorded in the experiment
% repetitions_map: a cell array describing the structure of the stimulus.
%   repetitions_map.stim_duration: the whole duration (in frames) of the stimulus
%   repetitions_map.names{i}: the name of the i-th repeated patterns of the stimulus
%   repetitions_map.start_indexes{i}: an array representing the indexes of the starting frame of the i-th repeated pattern
%   repetitions_map.durations{i}: the duration (in frames) of the i-th repeated pattern
% is_looping: if true, we assume the stimulus is repeated in loop.
%             if false, we assume the stimulus is just played once.


frame2frame_interval = median(diff(triggers));

rep_names = repetitions_map.names;
rep_indexes = repetitions_map.start_indexes;
rep_durations = repetitions_map.durations;

n_patterns = numel(rep_names);
n_triggers = numel(triggers);

% we initialize the repetitions:
repetitions.names = rep_names;
repetitions.durations  = cell(1, n_patterns);
repetitions.rep_begins = cell(1, n_patterns);

% for each repeated pattern, we want to compute the repetitions
for i_pattern = 1:n_patterns
    
    indexes = rep_indexes{i_pattern};
    
    % if the stimulus was looped, we compute how many times it was looped.
    % The number of loops correpsons to the number of recorded event markers
    % divided by the number of time steps of the stimulus
    if is_looping
        n_loops = ceil(n_triggers / repetitions_map.stim_duration);
    else
        n_loops = 1;
    end
    
    % once we know the number of loops, we add add to the repetitions 
    % a new set of indexes for each loop.
    for i_block = 2:n_loops
        loop_indices = indexes + repetitions_map.stim_duration;
        indexes = [indexes loop_indices];
    end
    
    % we finally assign the triggers to each pattern repetition.
    indexes = indexes(indexes <= numel(triggers));
    
    
    repetitions.rep_begins{i_pattern} = triggers(indexes);   
    repetitions.durations{i_pattern} = rep_durations{i_pattern} * frame2frame_interval;
end

