function spots_by_pattern = getSpotsInPatterns(stim_matrix)

patterns_2_spots = logical(stim_matrix);
[n_patterns, n_spots] = size(patterns_2_spots);
spots_by_pattern = cell(1, n_spots);

for i_p = 1:n_patterns
    spots_by_pattern{i_p} = find(patterns_2_spots(i_p, :));
end

