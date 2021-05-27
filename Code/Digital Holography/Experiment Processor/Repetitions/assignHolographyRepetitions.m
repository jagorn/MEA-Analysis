function stimTable = assignHolographyRepetitions(stimTable, exp_id)
% Assigns to each holography section of the experiment the corresponding repetitions.
% All the repetitions are added as a new field 'repetitions' to the sections
% struct 'holographyTable'.

% repetitions is struct describing the structure of the stimulus.
%   repetitions.patterns{i}:        the structure of the i-th repeated patterns of the stimulus
%   repetitions.rep_begins{i}:      an array indicating the first trigger of each repetition of the i-th pattern
%   repetitions.durations{i}:       the duration (in frames) of the i-th pattern

for i_section = 1:numel(stimTable)
    section_id = stimTable(i_section).id;
    stim_id = stimTable(i_section).stimulus;
    triggers = stimTable(i_section).triggers;
    durations = 1/stimTable(i_section).frame_rate;
    
    [holography_total_block, holography_block_type] = getHolographyFrames(exp_id, stim_id);
    repetitions = computeHolographyRepetitions(triggers, durations, holography_total_block, holography_block_type);
    
    stimTable(i_section).repetitions = repetitions;
    fprintf("\t%s : repetitions computed\n", section_id);
end