function plotClassCard(typeId, experiments)
% Plots a panel with all information about a cluster of cells:
% - Average Temporal Spike Triggered Average
% - Average PSTH for a choosen stimulus.
% - Mosaics of Receptive Fields

% INPUTS:
% typeId:                   the id number of the cluster.
% experiments (optional):   the name of experiments for which to display the mosaics.
%                           if not specified, all the experiments are used.


if ~exist('experiments', 'var')
    load(getDatasetMat(), 'experiments');
end

indices = classIndices(typeId);
figName = strcat("Class ", typeId);

plotIndicesCard(figName, indices, experiments);