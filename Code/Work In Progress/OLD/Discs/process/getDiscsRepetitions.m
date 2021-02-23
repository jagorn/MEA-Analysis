function discs = getDiscsRepetitions(discs_triggers, discs)

for i_disc = 1:numel(discs)
    discs(i_disc).rep_begin = discs_triggers(discs(i_disc).triggers_idx_onset);
    discs(i_disc).rep_end = discs_triggers(discs(i_disc).triggers_idx_offset);
end

discs = rmfield(discs, 'triggers_idx_onset');
discs = rmfield(discs, 'triggers_idx_offset');