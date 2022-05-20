function [distance_matrix, valid] = getCell2PatternShortestDistances(exp_id, section_id)

% Holo PSTHs and Patterns
[~ , i_section] = getHoloSection(exp_id, section_id);
holo_psths = getHolographyPSTHs(exp_id);
holo_psth = holo_psths(i_section);
holo_patterns = holo_psth.psth.patterns;
holo_positions = holo_psth.psth.pattern_positions.mea;

% Load Homographies
HChecker_2_DMD = getHomography('CHECKER20', 'DMD');
HDMD_2_Camera = getHomography('DMD', 'CAMERA');
HCamera_2_MEA = getHomography('CAMERA_X10', 'MEA');

% Compose Homographies
HChecker_2_MEA = HCamera_2_MEA * HDMD_2_Camera * HChecker_2_DMD;

% STAs
[~, ~, rfs, valid] = getSTAsComponents(exp_id);

% Compute Distances
n_patterns = size(holo_patterns, 1);
n_cells = numel(rfs);

distance_matrix = nan(n_patterns, n_cells);
for i_cell = 1:n_cells
    
    if ~ismember(i_cell, valid)
        continue
    end
    
    rf = rfs(i_cell);
    rf.Vertices = transformPointsV(HChecker_2_MEA, rf.Vertices);
    [cx, cy] = centroid(rf);
    
    for i_pattern = 1:n_patterns
        spots_pattern_idx = find(holo_patterns(i_pattern, :));
        n_spots = numel(spots_pattern_idx);
        
        spot_distances = zeros(1, n_spots);
        for i_spot = 1:n_spots
            position_pattern = holo_positions(spots_pattern_idx(i_spot), :);
            px = position_pattern(:, 1);
            py = position_pattern(:, 2);
            
            spot_distances(i_spot) = norm ([cx cy] - [px py]);
        end
        if isempty(spot_distances)
            distance_matrix(i_pattern, i_cell) = NaN;
        else
            distance_matrix(i_pattern, i_cell) = min(spot_distances);
        end
    end
end


