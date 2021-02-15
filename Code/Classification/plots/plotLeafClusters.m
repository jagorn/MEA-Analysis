function plotLeafClusters(class)
% Plots a panel with all the clusters in the 3 first components space:
% INPUTS:
% Class (Optional):         if provided, only sub-classes of the given
%                           class are shown.

if ~exist('class', 'var')
    class = "";
end
subclasses = getLeafClasses(class);
plotClassClusters(subclasses,  'PCA_Space', getPCASpace(class));
