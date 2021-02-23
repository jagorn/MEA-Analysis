function [activation_times, activation_overlaps, activation_distances] = getDiscLatencies(discs, cells_idx, discs_idx, transition, distance_treshold, overlap_treshold)

activation_times = [];
activation_overlaps = [];
activation_distances = [];
for i_cell = cells_idx(:)'
    for i_disc = discs_idx(:)'
        if ~isempty(discs.(transition){i_cell, i_disc})
            activation_times = [activation_times discs.(transition){i_cell, i_disc}];
            activation_overlaps = [activation_overlaps discs.overlaps(i_cell, i_disc)];
            activation_distances = [activation_distances discs.distances(i_cell, i_disc)];
        end
    end
end

constraints = activation_overlaps > overlap_treshold & activation_distances > distance_treshold;
activation_times = activation_times(constraints);
activation_overlaps = activation_overlaps(constraints);
activation_distances = activation_distances(constraints);