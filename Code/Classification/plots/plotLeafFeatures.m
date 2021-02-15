function plotLeafFeatures(class)
% Plots a panel the average feature vectors of all the cell types
% INPUTS:
% Class (Optional):         if provided, only sub-classes of the given
%                           class are shown.
if ~exist('class','var')
    class = "";
end

subclasses = getLeafClasses(class);
plotClassMeanFeatures(subclasses);
