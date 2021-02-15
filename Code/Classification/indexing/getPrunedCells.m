function cells_indices = getPrunedCells()

load(getDatasetMat(), 'clustersTable');
typeCodes = [clustersTable.Type];
cells_indices = endsWith(typeCodes, "_PRUNED.");

