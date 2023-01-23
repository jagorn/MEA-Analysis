function [idx_triangles, idx_vertices] = getSparseDelaunay(delaunay, sparse_threshold)

    triangles = delaunay.ConnectivityList();
    vertices = delaunay.Points();
    
    n_vertices = size(vertices, 1);
    n_triangles = size(triangles, 1);
    triangle_sides = zeros(n_triangles, 3);
    
    for i_triangle = 1:n_triangles
        t_vertices = vertices(triangles(i_triangle, :), :);
        
        for i_side = 1:3
            v1 = t_vertices(i_side, :);
            v2 = t_vertices(mod(i_side, 3) + 1, :);
            side = norm(v2 - v1);
            triangle_sides(i_triangle, i_side) = side;
        end
    end
    
    median_side = median(triangle_sides(:));
    max_sides = max(triangle_sides, [], 2);
    idx_triangles = max_sides < median_side * sparse_threshold;
    
    valid_triangles = triangles(idx_triangles, :);
    valid_vertices = unique(valid_triangles(:));
    idx_vertices = unfind(valid_vertices, n_vertices);




