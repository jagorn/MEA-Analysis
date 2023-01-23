function ci  = OptimizeCoverageSize(rfs, roi, varargin)

% Parameters
debug_def = false;
valid_rfs_def = 1:numel(rfs);
voronoi_def = [];

% Parse Input
p = inputParser;
addRequired(p, 'rfs');
addRequired(p, 'roi');
addParameter(p, 'Debug', debug_def);
addParameter(p, 'Valid_RFs', valid_rfs_def);
addParameter(p, 'Voronoi', voronoi_def);

parse(p, rfs, roi, varargin{:});
debug = p.Results.Debug;
valid_rfs = p.Results.Valid_RFs;
voronoi = p.Results.Voronoi;

rfs = rfs(valid_rfs);

% Compute the valid roi for coverage based on voronoi diagrams
if isempty(voronoi )
    mask = ones(roi(1), roi(2));
else
    mask = zeros(roi(1), roi(2));
    for voronoi_roi = voronoi'
        mask = mask | poly2mask(voronoi_roi.Vertices(:, 1), voronoi_roi.Vertices(:, 2), roi(1), roi(2));
    end
end

% Sort out vertices and centroids of all RFS
n_rfs = numel(rfs);
n_vertices = size(rfs(1).Vertices, 1);

rf_vertices = zeros(n_rfs, 2, n_vertices);
rf_centroids = zeros(n_rfs, 2);
for i_rf = 1:numel(rfs)
    rf = rfs(i_rf);
    rf_vertices (i_rf, :, :) = rf.Vertices';
    [cx, cy] = centroid(rf);
    rf_centroids(i_rf, 1) = cx;
    rf_centroids(i_rf, 2) = cy;
end

% Optimize Coverage wrt scale
f_coverage = @(rf_scale)-computeRFCoverage(rf_vertices, mask, 'Scale', rf_scale, 'Centroids', rf_centroids);
x0_coverage = 0.5;
opt_scale = fminsearch(f_coverage, x0_coverage);

% Compute Coverage
[simple_ci, simple_cov]  = computeRFCoverage(rf_vertices, mask);
[opt_ci,opt_cov]  = computeRFCoverage(rf_vertices, mask, 'Scale', opt_scale, 'Centroids', rf_centroids);

% Create optimal rfs;
rfs_opt_vertices = rescaleRFs(rf_centroids, rf_vertices, opt_scale);
rfs_opt = repmat(polyshape, [n_rfs, 1]);
for i_rf = 1:n_rfs
    rfs_opt(i_rf) = polyshape(squeeze(rfs_opt_vertices(i_rf, :, :))');
end
    
ci.cov_index = opt_ci;
ci.coverage = opt_cov;
ci.scaling = opt_scale;
ci.rfs_opt = rfs_opt;

ci.simple_ci = simple_ci;
ci.simple_cov = simple_cov;
ci.rfs = rfs;

ci.mask = mask;

% Compare Coverage with and without rescaling
if debug
    plotRFCoverage(ci);
end
