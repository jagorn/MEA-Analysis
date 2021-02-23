function matchClassesCard(type1, type2, experiments)

if ~exist('experiments', 'var')
    load(getDatasetMat(), 'experiments');
end

set1 = strtok(type1, ".");
set2 = strtok(type2, ".");


changeDataset(set2);
indices2 = classIndices(type2);

changeDataset(set1);
indices1 = classIndices(type1);

matchIndicesCard(type1, type2, indices1, indices2, experiments)