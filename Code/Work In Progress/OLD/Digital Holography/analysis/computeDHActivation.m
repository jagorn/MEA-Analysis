function computeDHActivation(dh_session_label, pattern_type)

n_min_reps = 10;
load(getDatasetMat, 'cellsTable');
dh_session_struct = load(getDatasetMat, dh_session_label);

n_cells = numel(cellsTable);
dh_session_struct.(dh_session_label).activation.(pattern_type) =  zeros(n_cells, 1);
for i_cell = 1:n_cells
    spike_counts = dh_session_struct.(dh_session_label).responses.(pattern_type).spikeCounts(i_cell, :);
    spike_counts = spike_counts(cellfun(@numel, spike_counts) >= n_min_reps);
    dh_session_struct.(dh_session_label).activation.(pattern_type)(i_cell) = computeActivation(spike_counts);
end

save(getDatasetMat, '-struct', 'dh_session_struct', "-append")




