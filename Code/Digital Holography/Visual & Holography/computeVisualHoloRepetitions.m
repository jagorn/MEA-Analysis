function repetitions = computeVisualHoloRepetitions(state_labels, visual_triggers, visual_sequence, dh_sequence, holography_total_block, holography_block_type)

% make sure visual sequence and dh sequence have the same length
if numel(visual_sequence) ~= numel(dh_sequence)
    error_struct.message = strcat("The visual sequence and the holographic sequence must have same number of steps");
    error_struct.identifier = strcat('MEA_Analysis:', mfilename);
    error(error_struct);
end

% make sure visual triggers have less steps than the sequences
if numel(visual_triggers) > numel(visual_sequence) || numel(visual_triggers) > numel(dh_sequence)
    error_struct.message = strcat("The number of visual steps exceeds the event sequence");
    error_struct.identifier = strcat('MEA_Analysis:', mfilename);
    error(error_struct);
end


visual_sequence = visual_sequence(1:numel(visual_triggers));
dh_sequence = dh_sequence(1:(numel(visual_triggers)-1));


dh_visual_indexes = containers.Map;

dh_begins = find(diff([0 dh_sequence(:)']) > 0);
dh_ends = find(diff([dh_sequence(:)' 0]) < 0) + 1;
dh_centers = round((dh_begins + dh_ends) / 2);
n_dh_steps = numel(dh_begins);

n_holo_frames = size(holography_total_block, 2);
n_holo_loops = ceil(n_dh_steps / n_holo_frames);

holography_total_block_sequence = repmat(holography_total_block, 1, n_holo_loops);
holography_total_block_sequence = holography_total_block_sequence(:, 1:n_dh_steps);

holography_block_type_sequence = repmat(holography_block_type, n_holo_loops, 1);
holography_block_type_sequence = holography_block_type_sequence(1:n_dh_steps);

% divide the Holographic Events by visual state.
for i_dh = 1:n_dh_steps
    dh_center = dh_centers(i_dh);
    visual_state = state_labels(visual_sequence(dh_center) + 1);
    
    if isKey(dh_visual_indexes, visual_state)
        dh_visual_indexes(visual_state) = [dh_visual_indexes(visual_state) i_dh];
    else
        dh_visual_indexes(visual_state) = i_dh;
    end
end


for i_state = 1:numel(state_labels)
    visual_state = state_labels(i_state);
    dh_indexes = dh_visual_indexes(visual_state);
    state_dh_total_block = holography_total_block_sequence(:, dh_indexes);
    state_dh_block_type = holography_block_type_sequence(dh_indexes);
    
    state_dh_begins = visual_triggers(dh_begins(dh_indexes));
    state_dh_ends = visual_triggers(dh_ends(dh_indexes));
    state_dh_durations = state_dh_ends - state_dh_begins;
    
    
    % dh repetitions
    repetitions(i_state).repetitions = computeHolographyRepetitions(state_dh_begins, state_dh_durations, state_dh_total_block, state_dh_block_type);
    repetitions(i_state).label = visual_state;
end



