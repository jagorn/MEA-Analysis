function plotClassMosaicStats(class_id, exp_id)

% load Dataset variables
load(getDatasetMat, 'spatialSTAs', 'classesTable', 'experiments');
idx = classExpIndices(class_id, exp_id);
[idx_uniques, idx_duplicates] = filterDuplicates(idx);
rfs_uniques = spatialSTAs(idx_uniques);
rfs_duplicates = spatialSTAs(idx_duplicates);

% load the mosaic statistics for [class_id] in [exp_id]
[nnnds, null_nnnds] = getClassNNNDs(class_id, exp_id);
coverage = getClassCoverage(class_id, exp_id);
[~, p] = getMosaicSignificance(class_id, exp_id);

plotMosaicStats(class_id, exp_id, coverage, rfs_uniques, rfs_duplicates, nnnds, null_nnnds, p)