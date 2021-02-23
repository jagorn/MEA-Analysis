function ndds = computeNDDs(rfs)

n_cells = numel(rfs);

rfs_areas = arrayfun(@area, rfs);
rfs_radius = sqrt(rfs_areas/pi);
sum_of_radius = rfs_radius + rfs_radius';
[cXs, cYs] = arrayfun(@centroid, rfs);

distances_mat = squareform(pdist([cXs', cYs']));
norm_distances_mat = 2*distances_mat ./ sum_of_radius + diag(ones(n_cells, 1)*inf);
mask = tril(true(size(norm_distances_mat)),-1);
ndds = norm_distances_mat(mask).';