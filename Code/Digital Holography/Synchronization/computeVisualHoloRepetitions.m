function computeVisualHoloRepetitions(visual_triggers, visual_sequence, dh_sequence, holography_total_block, holography_block_type)

% make sure visual sequence and dh sequence have the same length
if numel(visual_sequence) ~= numel(dh_sequence)
    error_struct.message = strcat("The visual sequence and the holographic sequence must have same number of steps");
    error_struct.identifier = strcat('MEA_Analysis:', mfilename);
    error(error_struct);
end

% make sure visual triggers have less steps than the sequences
if numel(visual_triggers) > numel(visual_sequence) || numel(visual_triggers) > numel(dh_sequence) || numel(visual_triggers) > size(holography_total_block, 1)
    error_struct.message = strcat("The number of visual steps exceeds the event sequence");
    error_struct.identifier = strcat('MEA_Analysis:', mfilename);
    error(error_struct);
end

visual_states = unique(visual_sequence);

dh_begins_idx = diff([0 dh_sequence(:)] > 0 );
dh_ends_idx = diff([dh_sequence(:) 0] < 0 );

for visual_state = visual_states
    state_idx = visual_sequence == visual_state;
    
    state_dh_begins = visual_triggers(state_idx & dh_begins_idx);
    state_dh_ends = visual_triggers(state_idx & dh_ends_idx);
    
    state_dh_total_block = visual_triggers(holography_total_block);
    state_dh_block_type = visual_triggers(holography_block_type);
    state_dh_duratinos = state_dh_ends - state_dh_ends;
    
    % dh repetitions
    state_dh_repetitions = computeHolographyRepetitions(state_dh_begins, state_dh_duratinos, state_dh_total_block, state_dh_block_type);
end

