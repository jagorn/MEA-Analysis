function plotClassClusters(typeIDs, varargin)

p = inputParser;
addRequired(p, 'typeIDs');
addParameter(p, 'PCA_Space', []);

parse(p, typeIDs, varargin{:});
pcaSpaceID = p.Results.PCA_Space;

if isempty(pcaSpaceID)
    % assume all the classes are from the same pca space
    pcaSpaceID = getPCASpace(typeIDs(1));
end
 
load(getDatasetMat, 'PCAs');
pcaSpace = {PCAs.(pcaSpaceID)};

text = strcat("Cell Clusters in 3 principal components from ", pcaSpaceID, " space");
figure('Name', text);

colors = getColors(numel(typeIDs));
for iType = 1:numel(typeIDs)
    typeId = typeIDs(iType);
    indices = classIndices(typeId);
    cellsPCs = cell2mat(pcaSpace(indices)');
    
    scatter3(cellsPCs(:, 1), cellsPCs(:, 2), cellsPCs(:, 3), [], colors(iType, :), 'filled');
    hold on   
end    
 hold off
 legend(typeIDs)
 title(text, "Interpreter", "none");