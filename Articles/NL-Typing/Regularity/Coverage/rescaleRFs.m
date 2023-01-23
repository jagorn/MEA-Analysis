function new_vertices = rescaleRFs(centers, vertices, scale)
vertex_centers = repmat(centers, [1, 1, 360]);
new_vertices = (vertices - vertex_centers) * scale + vertex_centers;

% figure();
% hold on;
% scatter(centers(:, 1), centers(:, 2), 'red', 'Filled');
% n_cells = size(vertices, 1);
% ps = repmat(polyshape, [n_cells, 1]);
% for s = 0.2:0.2:1
%     new_vertices = (vertices - vertex_centers) * s + vertex_centers;
%     for i = 1:n_cells
%         ps(i) = polyshape(squeeze(new_vertices(i, :, :))');
%         plot(ps(i), 'FaceColor', 'none', 'FaceAlpha', 1-s);
%     end
% end
% 
% daspect([1 1 1]);


