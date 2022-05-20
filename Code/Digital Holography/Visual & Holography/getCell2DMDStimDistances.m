function [distances, valid_stas] = getCell2DMDStimDistances(exp_id, holo_section_id, varargin)

% Parse Input
p = inputParser;
addRequired(p, 'exp_id');
addRequired(p, 'holo_section_id');
addParameter(p, 'Cell_Idx', []);
addParameter(p, 'Normalize', false);
addParameter(p, 'Show_Plots', false);

parse(p, exp_id, holo_section_id, varargin{:});
cell_idx = p.Results.Cell_Idx;
do_normalization = p.Results.Normalize;
show_plots = p.Results.Show_Plots;

% Holo Section
holo_section = getHoloSection(exp_id, holo_section_id);

% Load Homographies
HChecker_2_DMD = getHomography('CHECKER20', 'DMD');
HDMD_2_Camera = getHomography('DMD', 'CAMERA');

HCameraX10_2_MEA = getHomography('CAMERA_X10', 'MEA');
HCameraHolo_2_MEA_Stim = getHomography(holo_section.h_ref, 'MEA', exp_id);

% Compose Homographies
HStim_2_MEA = HCameraHolo_2_MEA_Stim * HDMD_2_Camera;
HSTA_2_MEA = HCameraX10_2_MEA * HDMD_2_Camera * HChecker_2_DMD;

% Get visual stim
stim_polygon = getDMDStimShape(holo_section.stimulus);
stim_polygon.Vertices = transformPointsV(HStim_2_MEA, stim_polygon.Vertices);
[xs_stim, ys_stim] = boundary(stim_polygon);
[cx_stim, cy_stim] = centroid(stim_polygon);

% STAs
[~, ~, rfs, ~] = getSTAsComponents(exp_id);
[~, radii, ~, ~, valid_stas] = getMEASTAs(exp_id);
n_cells = numel(rfs);

if isempty(cell_idx)
    cell_idx = 1:n_cells;
end

% Compute Distances
distances = nan(1, n_cells);

% Load Image
if show_plots
    image = imread(fullfile(getH_ImagesPath(),'camera_center_x10.jpg'));
    [img_2mea, imgRef_2mea] = transformImage(HCameraX10_2_MEA, image);
end

for i_cell = cell_idx
    if ~ismember(i_cell, valid_stas)
        continue
    end
    
    rf = rfs(i_cell);
    rf.Vertices = transformPointsV(HSTA_2_MEA, rf.Vertices);
    [xs_cell, ys_cell] = boundary(rf);
    [cx_cell, cy_cell] = centroid(rf);
    
    point_cell = [cx_cell, cy_cell];
    point_stim = [cx_stim, cy_stim];
    
    rf_intersection = intersect(rf, stim_polygon);
    if isempty(rf_intersection.Vertices)
        min_d = +inf;
        for ix_cell = 1:numel(xs_cell)
            for ix_stim = 1:numel(xs_stim)
                d = norm ([xs_stim(ix_stim) ys_stim(ix_stim)] - [xs_cell(ix_cell) ys_cell(ix_cell)]);
                if d < min_d
                    min_d = d;
                    point_cell = [xs_cell(ix_cell) ys_cell(ix_cell)];
                    point_stim = [xs_stim(ix_stim) ys_stim(ix_stim)];
                end
            end
        end
        distances(i_cell) = min_d;
        if do_normalization
            distances(i_cell) = (distances(i_cell) + radii(i_cell)) / radii(i_cell);
        end
    else
        distances(i_cell) = 0;
    end
    
    
    if show_plots
        figure();
        imshow(img_2mea, imgRef_2mea);
        hold on;
        
        fill(xs_stim, ys_stim, 'w', 'FaceAlpha', 0.5);
        fill(xs_cell, ys_cell, 'r', 'FaceAlpha', 0.5);
        scatter(point_cell(1), point_cell(2), 50, 'k', 'Filled');
        scatter(point_stim(1), point_stim(2), 50, 'k', 'Filled');
        
        plot([point_cell(1), point_stim(1)], [point_cell(2), point_stim(2)], 'k', 'LineWidth', 2)
        
        x_mid = (cx_stim + cx_cell)/2;
        y_mid = (cy_stim + cy_cell)/2;
        
        if do_normalization
            label = strcat(num2str(distances(i_cell)), ' radii');
        else
            label = strcat(num2str(round(distances(i_cell))), ' microns');
        end
        text(x_mid, y_mid, label, 'Color', 'w', 'FontSize', 14);
        pause(2);
        close();
    end
end


