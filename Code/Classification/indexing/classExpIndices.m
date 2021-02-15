function indices = classExpIndices(typeId, experiment)

load(getDatasetMat(), 'clustersTable');

expIds = [clustersTable.Experiment];
exp_indices = strcmp(expIds, experiment);

if  not(endsWith(typeId, "."))
    typeId = strcat(typeId, ".");
end
typeCodes = [clustersTable.Type];
class_indices = startsWith(typeCodes, typeId);

indices = and(class_indices, exp_indices);