function plotSubClusters(classId, varargin)

p = inputParser;
addRequired(p, 'classId');
addParameter(p, 'PCA_Space', []);

parse(p, classId, varargin{:});
pcaSpace = p.Results.PCA_Space;

if isempty(pcaSpace)
    pcaSpace = getPCASpace(classId);
end

subclasses = getSubclasses(classId);
if numel(subclasses) > 0
    plotClassClusters(subclasses,  'PCA_Space', pcaSpace);
end
