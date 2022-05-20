function distance_matrix = getPatternShortestDistances(exp_id, section_id)

% Holo PSTHs and Patterns
[~ , i_section] = getHoloSection(exp_id, section_id);
holo_psths = getHolographyPSTHs(exp_id);
holo_psth = holo_psths(i_section);
holo_patterns = holo_psth.psth.patterns;
holo_positions = holo_psth.psth.pattern_positions.mea;

n_patterns = size(holo_patterns, 1);


% Compute Distances
distance_matrix = zeros(1, n_patterns);

for i_pattern = 1:n_patterns
    spots_pattern_idx = logical(holo_patterns(i_pattern, :));
    position_pattern = holo_positions(spots_pattern_idx, :);
    
    shortest_distance = +inf;
    for spot_1 = 1:size(position_pattern, 1)
        for spot_2 = 1:size(position_pattern, 1)
            if spot_2 ~= spot_1
                
                x1 = position_pattern(spot_1, 1);
                y1 = position_pattern(spot_1, 2);
                
                x2 = position_pattern(spot_2, 1);
                y2 = position_pattern(spot_2, 2);
                
                distance = norm ([x1 y1] - [x2 y2]);
                if distance < shortest_distance
                    shortest_distance = distance;
                end
            end
        end
    end
    distance_matrix(i_pattern) = shortest_distance;
end


