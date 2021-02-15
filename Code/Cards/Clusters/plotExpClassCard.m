function classNotEmpty = plotExpClassCard(classId, expId)
% Plots a panel with all information about a cluster of cells in a given experiment:
% - Average Temporal Spike Triggered Average
% - Average PSTH for a choosen stimulus.
% - Mosaic of Receptive Fields
% - All the ids of the cells belonging to the cluster.

% INPUTS:
% typeId:	the id number of the cluster.
% expId:	the id of the experiment

indices = and(classIndices(classId), expIndices(expId));
classNotEmpty = sum(indices>0);

if classNotEmpty
    plotExpIndicesCard(indices);
    h = suptitle(['Class ' char(classId) ', Exp. ' char(expId)]);
    h.Interpreter = 'None';
else
    fprintf("INFO: no cells of type %s in experiment #%s\n", classId, expId);
end

