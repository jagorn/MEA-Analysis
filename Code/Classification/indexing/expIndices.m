function indices = expIndices(expId)

load(getDatasetMat(), 'cellsTable');

expIds = [cellsTable.experiment];
indices = strcmp(expIds, expId);



