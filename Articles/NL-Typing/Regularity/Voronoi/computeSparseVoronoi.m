function [voronoi_regions, delaunay_triangles, valid_cells] = computeSparseVoronoi(somas, roi, varargin)

% Parameters
sparse_threshold_def = [];
debug_def = false;

% Parse Input
p = inputParser;
addRequired(p, 'cells');
addRequired(p, 'roi');
addParameter(p, 'Sparseness_Threshold', sparse_threshold_def);
addParameter(p, 'Debug', debug_def);

parse(p, somas, roi, varargin{:});
sparse_threshold = p.Results.Sparseness_Threshold;

% Do Delaunay Triangulation
delaunay = delaunayTriangulation(somas(:, 1:2));
triangles = getDelaunayTriangles(delaunay);

n_triangles = numel(triangles);
n_cells = size(somas, 1);

% Remove Holes from Delaunay Triangles
if ~isempty(sparse_threshold)
    [valid_triangles, valid_mosaic] = getSparseDelaunay(delaunay, sparse_threshold);
else
    valid_mosaic = true(n_cells, 1);
    valid_triangles = true(n_triangles, 1);
end

% Do Voronoi Diagram
[v_vertices,v_regions] = voronoiDiagram(delaunay);
n_voronoi = numel(v_regions);
    
% Create Polygons
voronoi = repmat(polyshape, [n_voronoi, 1]);
for i_voronoi = 1:n_voronoi
    i_vertices = v_regions{i_voronoi};
    poly_vertices = v_vertices(i_vertices, :);
    % Remove polygons with...
    
    % ...infinite vertices
    if any(isinf(poly_vertices(:)))
        valid_mosaic(i_voronoi) = false;
        valid_triangles(trianglesWithVertices(delaunay, i_voronoi)) = false;
        continue;
    end
    
    % ...vertices outside roi
    if any(poly_vertices(:, 1) < 0) || ...
       any(poly_vertices(:, 2) < 0) || ...
       any(poly_vertices(:, 1) > roi(1)) || ...
       any(poly_vertices(:, 2) > roi(2))
       valid_mosaic(i_voronoi) = false;
           valid_triangles(trianglesWithVertices(delaunay, i_voronoi)) = false;
       continue;
    end
    voronoi(i_voronoi) = polyshape(poly_vertices(:, 1), poly_vertices(:, 2));
end

triangles_vertices = delaunay.ConnectivityList();
triangles_vertices_valid = triangles_vertices(valid_triangles, :);
vertices_to_use = unique(triangles_vertices_valid(:));
valid_vertices = unfind(vertices_to_use, n_cells);
valid_cells = valid_mosaic & valid_vertices;
    
voronoi_regions = voronoi(valid_cells);
delaunay_triangles = triangles(valid_triangles);