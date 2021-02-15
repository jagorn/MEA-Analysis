function class = treeClassification_recursive(name, indicesClass, n)

global nIterations;
global nPcaComponents;
global features;
global nMaxBranchings;

global clustersTable;
global PCAs;


% Check if the current class is admissible as a leaf cluster
if clusterIsAdmissible(indicesClass)
    class.name = name;
    class.sub = {};
else
    class = [];
end

backupLabels = [clustersTable(indicesClass).Type];

% Check if the current class will be pruned
if ~clusterIsAdmissible(indicesClass) && (~clusterIsSplittable(indicesClass) || n > nIterations)
    for iCell = 1:length(indicesClass)
        className = clustersTable(indicesClass(iCell)).Type;
        className = strcat(extractBefore(className, strlength(className)), "_PRUNED.");
        clustersTable(indicesClass(iCell)).Type = className;
    end
end
        
% Check if it is possible to split again the current cluster
if ~clusterIsSplittable(indicesClass) || n > nIterations   
    return
end

% Principal Components Reduction
traceMatrix = features{n};
pca = doPca(traceMatrix(indicesClass, :), nPcaComponents(n));

% Clusterize
try
    [classMapping, probs, numClass] = doClusterization(pca, nMaxBranchings(n));
catch
    fprintf("Clusterization of cluster %s failed\n", name)
    if ~clusterIsAdmissible(indicesClass)
        for iCell = 1:length(indicesClass)
            className = clustersTable(indicesClass(iCell)).Type;
            className = strcat(extractBefore(className, strlength(className)), "_PRUNED.");
            clustersTable(indicesClass(iCell)).Type = className;
        end
    end
    return;
end

% Update the PCA and clusters tables
for iCell = 1:length(indicesClass)
    pcaLvl = strcat("lvl", num2str(n + 1));
    PCAs(indicesClass(iCell)).(pcaLvl) = pca(iCell, :);  
    clustersTable(indicesClass(iCell)).Type = strcat(clustersTable(indicesClass(iCell)).Type, num2str(classMapping(iCell)), ".");
    clustersTable(indicesClass(iCell)).Prob = [clustersTable(indicesClass(iCell)).Prob, probs(iCell)];
end

% Recursive Classification on sub-clusters
subclasses = {};
for nClass = 1:numClass
    subclassName = strcat(name, num2str(nClass), ".");
    subclassIndexes = indicesClass(classMapping == nClass);                
    subclass = treeClassification_recursive(subclassName, subclassIndexes, n + 1);
    if length(subclass) > 0
        subclasses = [subclasses, subclass];
    end
end

% If there are some subclasses, add them and return the whole subtree
if numel(subclasses) > 0
    class.name = name;
    class.sub = subclasses;
else
    % If all the sons were pruned, but this class is admissible, restore it
    if clusterIsAdmissible(indicesClass)
        for iIndex = 1:length(indicesClass)
            clustersTable(indicesClass(iIndex)).Type = backupLabels(iIndex);
        end
    end
end
        
