function [center, radius, vertices, surface, good_cells] = getMEASTAs(exp_id, camera_reference)

min_radius = 40;

if ~exist('camera_reference', 'var')
    camera_reference = 'CAMERA_X10';
end

% Load Homographies
HChecker_2_DMD = getHomography('CHECKER20', 'DMD');
HDMD_2_Camera = getHomography('DMD', 'CAMERA');
HCamera_2_MEA = getHomography(camera_reference, 'MEA');

% Compose Homographies
HChecker_2_MEA = HCamera_2_MEA * HDMD_2_Camera * HChecker_2_DMD;

% STAs
[temporal, spatial, rfs, valid] = getSTAsComponents(exp_id);

n_cells = numel(rfs);
center = zeros(n_cells, 2);
surface = zeros(n_cells, 1);
radius = zeros(n_cells, 1);

for i_cell = 1:n_cells
    
    if ~ismember(i_cell, valid)
        continue
    end
    
    rf = rfs(i_cell);
    warning('off', 'MATLAB:polyshape:repairedBySimplify');
    rf.Vertices = transformPointsV(HChecker_2_MEA, rf.Vertices);
    [cx, cy] = centroid(rf);
    
    longest_d = 0;
    for v = 1:size(rf.Vertices, 1)
        d = norm ([cx cy] - [rf.Vertices(v, 1) rf.Vertices(v, 2)]);
        if d > longest_d
            longest_d = d;
        end
    end

    center(i_cell, :) = [cx, cy];
    vertices(i_cell) = rf;
    surface(i_cell) = area(rf);
    radius(i_cell) = longest_d;  % sqrt(area(rf) / pi);
end

good_cells = intersect(find(radius >= min_radius), valid);



