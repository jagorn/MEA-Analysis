loadDataset;

tmp_sstas = [];
for i = 1:numel(spatialSTAs)
    tmp_sstas = [tmp_sstas, polyshape(spatialSTAs(i).x, spatialSTAs(i).y)];
end
spatialSTAs = tmp_sstas;
save(getDatasetMat(), 'spatialSTAs', '-append')