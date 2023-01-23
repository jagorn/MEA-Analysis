function plotMosaic(cells, roi, varargin)


% Parameters
voronoi_cells_def = false(size(cells, 1), 1);
voronoi_def = [];
delaunay_def = [];
rfs_def = [];
soma_size_def = 10;  % microns

% Parse Input
p = inputParser;
addRequired(p, 'cells');
addRequired(p, 'roi');
addParameter(p, 'Voronoi_Cells', voronoi_cells_def);
addParameter(p, 'Voronoi', voronoi_def);
addParameter(p, 'Delaunay', delaunay_def);
addParameter(p, 'RFs', rfs_def);

parse(p, cells, roi, varargin{:});
voronoi_cells = p.Results.Voronoi_Cells;
voronoi = p.Results.Voronoi;
delaunay = p.Results.Delaunay;
rfs = p.Results.RFs;

hold on;

% Cell Size
n_cells = size(cells, 1);
if size(cells, 2) >= 3
    soma_positions = cells(:, 1:2);
    soma_sizes = cells(:, 3);
else
    soma_positions = cells;
    soma_sizes = ones(n_cells, 1) * soma_size_def;
end

% Voronoi
if ~isempty(voronoi)
    plot(voronoi, 'FaceColor', 'Yellow');
end

% Delaunay
if ~isempty(delaunay)
    plot(delaunay, 'FaceColor', 'None');
end

% Cells
scatter(soma_positions(voronoi_cells, 1), soma_positions(voronoi_cells, 2), 30, [0.8, 0.2, 0.2], 'Filled');
viscircles(soma_positions(voronoi_cells, :), soma_sizes(voronoi_cells), 'Color', 'Red');

scatter(soma_positions(~voronoi_cells, 1), soma_positions(~voronoi_cells, 2), 30, [0.1, 0.1, 0.1], 'Filled');
viscircles(soma_positions(~voronoi_cells, :), soma_sizes(~voronoi_cells), 'Color', 'Black');

% RFs
if ~isempty(rfs)
    plot(rfs(voronoi_cells), 'EdgeColor', 'k', 'LineStyle', ':', 'FaceColor', 'red', 'FaceAlpha', 0.2);
    plot(rfs(~voronoi_cells), 'EdgeColor', 'k', 'LineStyle', ':', 'FaceColor', 'black', 'FaceAlpha', 0.2);
end

% ROI
roi_polygon = polyshape([0, 0; roi(1), 0; roi(1), roi(2); 0, roi(2)]);
plot(roi_polygon, 'LineStyle', '--',  'EdgeColor', 'black', 'FaceColor', 'None');

% Figure Specs
xlim([-roi(1)/10, roi(1) + roi(1)/10]);
ylim([-roi(2)/10, roi(1) + roi(2)/10]);
daspect([1, 1, 1]);

xlabel("size [microns]");
ylabel("size [microns]");

