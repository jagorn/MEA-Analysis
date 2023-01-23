function [ci, coverage] = computeRFCoverage(rf_vertices, mask_valid, varargin)


% Parameters
rf_scale_def = [];
rf_centroid_def = [];

% Parse Input
p = inputParser;
addRequired(p, 'rf_vertices');
addRequired(p, 'mask_valid');
addParameter(p, 'Scale', rf_scale_def);
addParameter(p, 'Centroids', rf_centroid_def);

parse(p, rf_vertices, mask_valid, varargin{:});
rf_scale = p.Results.Scale;
rf_centroids = p.Results.Centroids;

if ~isempty(rf_scale) && ~isempty(rf_centroids)
    rf_vertices = rescaleRFs(rf_centroids, rf_vertices, rf_scale);
end

[roi_x, roi_y] = size(mask_valid);
coverage = zeros(roi_x, roi_y);
for i_rf = 1:size(rf_vertices, 1)
    rf_v_x = squeeze(rf_vertices(i_rf, 1, :));
    rf_v_y = squeeze(rf_vertices(i_rf, 2, :));
    rf_mask = poly2mask(rf_v_x, rf_v_y, roi_x, roi_y);
    rf_valid_mask = mask_valid & rf_mask;
    coverage = coverage + rf_valid_mask;
end

ci = sum(coverage(:) == 1) / sum(mask_valid(:));

