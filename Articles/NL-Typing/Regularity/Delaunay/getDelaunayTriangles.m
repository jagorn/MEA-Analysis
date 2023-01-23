function triangles = getDelaunayTriangles(delunay)

n_triangles = size(delunay, 1);

triangles = repmat(polyshape, [1, n_triangles]);
for i_triangle = 1:n_triangles
    vertex_indices = delunay.ConnectivityList(i_triangle, :);
    vertexes = delunay.Points(vertex_indices, :);
    triangle = polyshape(vertexes);
    triangles(i_triangle) = triangle;
end