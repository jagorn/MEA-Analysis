function classesTable = buildClassesTable()
% After the clustering has been performed, use this method to generate
% a table with all the informations about the clusters.
% Each entry represents a cluster, with the given fields:
% - name: name of the cluster
% - size: size of the cluster
% - indices: indices of the cells belonging to the cluster
% - psth: average feature psth of the cluster
% - sta: average temporal sta of the cluster
% - ploarity: polarity of the cluster (ON or OFF)
% - snr_psth: signal-to-noise ratio of the feature psth
% - snr_sta: signal-to-noise ratio of the sta

loadDataset();

classNames = unique([clustersTable.Type]);
nClasses = length(classNames);

classesTable = struct(  'name',     cell(1, nClasses), ...
                        'size',     cell(1, nClasses), ...
                        'indices',  cell(1, nClasses) ...
                     );
for iClass = 1:numel(classNames)
    name = classNames(iClass);
    indices = classIndices(name);
    
    classesTable(iClass).name = classNames(iClass);
    classesTable(iClass).size = sum(indices);
    
    classesTable(iClass).PSTH = mean(features_psths(indices, :));
    classesTable(iClass).STA = mean(temporalSTAs(indices, :));
    
    if   abs(max(classesTable(iClass).STA)) > abs(min(classesTable(iClass).STA))
        classesTable(iClass).POLARITY = "ON";
    else
        classesTable(iClass).POLARITY = "OFF";
    end

    classesTable(iClass).SNR_PSTH = doSNR(features_psths(indices, :));
    classesTable(iClass).SNR_STA = doSNR(temporalSTAs(indices, :));
    classesTable(iClass).indices = indices;
end

classesTableNotPruned = classesTable;

% remove pruned
pruned = false(nClasses, 1);
for iClass = 1:nClasses
    pruned(iClass) = endsWith(classesTable(iClass).name, "_PRUNED.");
end
classesTable(pruned) = [];

save(getDatasetMat, 'classesTable', 'classesTableNotPruned', '-append');    
