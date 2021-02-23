function idx_duplicates = findDuplicateRFs(idx, distance_thresh, area_thresh)

% Load Receptive Fields
load(getDatasetMat(), 'spatialSTAs', 'stas');
rfs = spatialSTAs(idx);

% Load Receptive Fields
load(getDatasetMat(), 'spatialSTAs', 'stas');
n_cells = sum(idx);

% Get RFs centers and boundaries
[cXs, cYs] = arrayfun(@centroid, rfs);

% Find doublets of cells too close to each others
distances_mat = triu(squareform(pdist([cXs', cYs']))) + tril(ones(n_cells, n_cells)*inf);
[idx_RF1, idx_RF2] = find(distances_mat < distance_thresh);

idx_duplicates = boolean(zeros(1, length(idx)));
for i = 1:length(idx_RF1)
    i_RF1 = idx_RF1(i);
    i_RF2 = idx_RF2(i);   
    intersection = intersect(rfs(i_RF1), rfs(i_RF2));
    
    A1 = area(rfs(i_RF1));
    A2 = area(rfs(i_RF2));
    A12 = area(intersection);

    if A12/A1 > area_thresh && A12/A2 > area_thresh
        
        idx_cells = find(idx);
        i_cell2 = idx_cells(i_RF2);
        idx_duplicates(i_cell2) = true;
    end
end