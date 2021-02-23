function pattern_idx = getPatternsWithSpots(dh_session, type, spots)

pattern2spots = logical(dh_session.stimuli.(type));
[n_patterns, n_spots] = size(pattern2spots);

if islogical(spots)
    spots = find(spots)';
end

pattern_idx = true(n_patterns, 1);
for pattern = 1:n_patterns
    for spot = spots
        if pattern2spots(pattern, spot) == 0
            pattern_idx(pattern) = false;
        end
    end
end
            

