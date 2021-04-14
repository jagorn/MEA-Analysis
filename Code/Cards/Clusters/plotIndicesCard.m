function plotIndicesCard(card_title, indices, experiments)
% Plots a panel with all information about a set of cells:
% - Average Temporal Spike Triggered Average
% - Average PSTH for a choosen stimulus.
% - Mosaics of Receptive Fields

% INPUTS:
% indices:                  the ids of the cells in the set.
% experiments (optional):   the name of experiments for which to display the mosaics.
%                           if not specified, all the experiments are used.

if ~exist('experiments', 'var')
    load(getDatasetMat(), 'experiments');
end

nRows = ceil(numel(experiments) / 3) + 1;
figure('Name', card_title);

subplot(nRows, 4, [1, 2, 3])
[default_pattern, default_label] = getDefaultPattern();
plotPSTH(indices, default_pattern, default_label);

subplot(nRows, 4, 4)
plotTSTAs(indices);

for iExp = 1:numel(experiments)
    exp_indices = expIndices(experiments{iExp}) & indices;
    
    i_plot = iExp + 3;
    subplot(nRows, 3, i_plot);
    plotRFs(exp_indices);
    title(experiments{iExp}, "Interpreter", "none")
end

ss = get(0,'screensize');
width = ss(3);
height = ss(4);
vert = 300 * nRows;
horz = 900;
set(gcf,'Position',[(width/2)-horz/2, (height/2)-vert/2, horz, vert]);