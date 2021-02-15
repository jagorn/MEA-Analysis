function Ns = classExpNs(typeId, experiment)
load(getDatasetMat(), 'cellsTable')
indices = classExpIndices(typeId, experiment);
Ns = [cellsTable(indices).N];
