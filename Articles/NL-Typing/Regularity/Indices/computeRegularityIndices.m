function [nnri, vvri, er] = computeRegularityIndices(somas, rfs, roi, vonoroi_diag, varargin)

% Parameters
valid_cells_def = 1:size(somas, 1);
nn_bin_def = 25 ; % microns
nn_max_def = 250 ; % microns
vv_bin_def = 25^2 ; % microns^2
vv_max_def = 250^2 ; % microns^2
er_bin_def = 25 ; % microns
er_max_def = 250 ; % microns

% Parse Input
p = inputParser;
addRequired(p, 'cells');
addRequired(p, 'roi');
addRequired(p, 'vonoroi');
addParameter(p, 'Valid_Cells', valid_cells_def);
addParameter(p, 'NN_Bin', nn_bin_def);
addParameter(p, 'NN_Max', nn_max_def);
addParameter(p, 'VV_Bin', vv_bin_def);
addParameter(p, 'VV_Max', vv_max_def);
addParameter(p, 'ER_Bin', er_bin_def);
addParameter(p, 'ER_Max', er_max_def);

parse(p, somas, roi, vonoroi_diag, varargin{:});

valid_cells = p.Results.Valid_Cells;
nn_bin = p.Results.NN_Bin;
nn_max = p.Results.NN_Max;
vv_bin = p.Results.VV_Bin;
vv_max = p.Results.VV_Max;
er_bin = p.Results.ER_Bin;
er_max = p.Results.ER_Max;

n_cells = sum(valid_cells>0);
positions = somas(valid_cells, 1:2);

% Null indices
if any(isnan(somas(:)))
    nnri.ri = nan;
    vvri.ri = nan;
    er.effective_radius = nan;
    return
end

% Compute NN distances
d_vector = pdist(positions);
d_matrix = squareform(d_vector) + diag(inf(n_cells, 1));
d_min = min(d_matrix);

% Discard Cells too close to the edge
% d_edge = distanceToEdge(positions, roi)';
% d_min(d_min > d_edge) = [];

% Discard Cells too far away
% radii = inf(1, numel(rfs));
% for i_rf = 1:numel(rfs)
%     rf  = rfs(i_rf);
%     n_points = size(rf.Vertices, 1);
%     for ii = 1:n_points
%         jj = mod(ii + 180, 360)+1;
%         r = norm(rf.Vertices(ii, :) - rf.Vertices(jj, :))/2;
%         if r < radii(i_rf)
%             radii(i_rf) = r;
%         end
%     end
%
% end
% d_min(d_min > radii* 3) = [];

% NN Histogram
nn_bins = 0:nn_bin:nn_max;
[nn_histo, ~] = histcounts(d_min, nn_bins);
nnri.ri = mean(d_min) / std(d_min);
nnri.bins = nn_bins;
nnri.histo = nn_histo;
nnri.distances = d_min;

% Compute Voronoi areas
if isempty(vonoroi_diag)
    vvri = [];
else
    v_areas = area(vonoroi_diag);
    vv_bins = 0:vv_bin:vv_max;
    [vv_histo, ~] = histcounts(v_areas, vv_bins);
    vvri.ri = mean(v_areas) / std(v_areas);
    vvri.bins = vv_bins;
    vvri.histo = vv_histo;
    vvri.areas = v_areas;
end

% Compute Density Profile
er = computeDensityProfile(positions, roi, er_bin, er_max);