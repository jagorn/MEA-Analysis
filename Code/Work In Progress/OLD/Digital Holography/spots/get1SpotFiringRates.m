function firing_rates_by_spots = get1SpotFiringRates(dh_session, i_cell)

spots_by_pattern = cell2mat(getSpotsInPatterns(dh_session.stimuli.single));
firing_rates_by_patterns = dh_session.responses.single.firingRates(i_cell, :, :);
firing_rates_by_spots = firing_rates_by_patterns(:, spots_by_pattern, :);

[n_cells, n_patterns, n_bins] = size(dh_session.responses.single.firingRates);
firing_rates_by_spots = reshape(firing_rates_by_spots, [n_patterns, n_bins]);