function i_triangles = trianglesWithVertices(delaunay, i_vertex)

m = delaunay.ConnectivityList == i_vertex;
i_triangles = any(m');
