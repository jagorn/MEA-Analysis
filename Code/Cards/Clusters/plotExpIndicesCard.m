function plotExpIndicesCard(indices)
% Plots a panel with all information about a set of cells in a given experiment:
% - Average Temporal Spike Triggered Average
% - Average PSTH for a choosen stimulus.
% - Mosaic of Receptive Fields
% - All the ids of the cells belonging to the cluster.

% INPUTS:
% indices:	the ids of the cells in the set.


loadDataset()
experiment = unique([cellsTable(indices).experiment]);
if numel(experiment) > 1
    error("cannot compare cells from different experiments");
end

figName = strcat("Figure");
figure('Name', figName);

subplot(2, 5, [1, 2, 3, 4])
[psth_pattern, psth_label] = getDefaultPSTH();
plotPSTH(indices, psth_pattern, psth_label);

subplot(2, 5, [6, 7])
plotTSTAs(indices);

subplot(2, 5, [8, 9]);
plotRFs(indices);
title("Receptive Fields", "Interpreter", "none");

subplot(2, 5, [5, 10]);
title(strcat("Exp #", experiment), "Interpreter", "none");
text(.2, .95, "INDICES:")

n_indices = sum(indices>0);
indices = [cellsTable(indices).N];
colors = getColors(n_indices);
for i = 1:n_indices
    text(.2, .9 - (.9 / n_indices * i), string(indices(i)), "Color", colors(i, :))
end
grid off
axis off

ss = get(0,'screensize');
width = ss(3);
height = ss(4);
vert = 750;
horz = 1000;
set(gcf,'Position',[(width/2)-horz/2, (height/2)-vert/2, horz, vert]);