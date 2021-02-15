function indices = classIndices(typeId)

load(getDatasetMat(), 'clustersTable');

if  not(endsWith(typeId, "."))
    typeId = strcat(typeId, ".");
end

typeCodes = [clustersTable.Type];
indices = startsWith(typeCodes, typeId);
