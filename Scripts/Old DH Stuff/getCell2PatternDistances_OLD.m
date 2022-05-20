function distance_matrix = getCell2PatternDistances_OLD(exp_id, section_id)

% Holo PSTHs and Patterns
[~ , i_section] = getHoloSection(exp_id, section_id);
holo_psths = getHolographyPSTHs(exp_id);
holo_psth = holo_psths(i_section);
holo_patterns = holo_psth.psth.patterns;
holo_positions = holo_psth.psth.pattern_positions.mea;

n_patterns = size(holo_patterns, 1);
n_cells = size(holo_psth.psth.responses, 2);

% Load Homographies
HChecker_2_DMD = getHomography('CHECKER20', 'DMD');
HDMD_2_Camera = getHomography('DMD', 'CAMERA');
HCamera_2_MEA = getHomography('CAMERA_X10', 'MEA');

% Compose Homographies
HChecker_2_MEA = HCamera_2_MEA * HDMD_2_Camera * HChecker_2_DMD;

% STAs
[~, ~, rfs, valid] = getSTAsComponents(exp_id);

% Compute Distances
distance_matrix = nan(n_cells, n_patterns);

for i_cell = valid(:)'
    
    rf = rfs(i_cell);
    rf.Vertices = transformPointsV(HChecker_2_MEA, rf.Vertices);
    [cx, cy] = centroid(rf);
        
    for i_pattern = 1:n_patterns
        spots_pattern_idx = logical(holo_patterns(i_pattern, :));
        position_pattern = holo_positions(spots_pattern_idx, :);
        px = sum(position_pattern(:, 1)) / size(position_pattern, 1);
        py = sum(position_pattern(:, 2)) / size(position_pattern, 1);
        
        distance_matrix(i_cell, i_pattern) = norm ([cx cy] - [px py]);
    end
end


