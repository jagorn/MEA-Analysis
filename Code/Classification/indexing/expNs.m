function Ns = expNs(experiment, idx)

load(getDatasetMat(), 'cellsTable')
indices = expIndices(experiment);

Ns = [cellsTable(indices).N];

if exist('idx', 'var')
    Ns = Ns(idx);
end