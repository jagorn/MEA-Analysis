function plotCellCard(cell_id, psth_pattern, psth_label)
% Plots a panel with all information about a cell:
% - Temporal Spike Triggered Average
% - Inter-Spike Interval Histogram
% - Receptive Field
% - PSTH for a choosen stimulus.

% INPUTS:
% cell_id:              the id number of the cell.
% pattern (optional):   the name of the psth to be displayed.
%                       if not provided, the default one is used.


% If the psth name is not specified, we use the default one.
if ~exist('psth_pattern', 'var') || ~exist('psth_label', 'var')
    [psth_pattern, psth_label] = getDefaultPSTH();
end

% load all info about the cell
load(getDatasetMat, 'cellsTable', 'clustersTable');
cell_N = cellsTable(cell_id).N;
cell_exp = char(cellsTable(cell_id).experiment);

% if the clustering has been done, let's also print the cell type.
if exist('clustersTable', 'var')
    cell_type = clustersTable(cell_id).Type;
else
    cell_type = 'unknown';
end


figure('Name', ['Cell_#' char(cell_id)]);

% PSTH
subplot(2, 3, [1 2])
plotPSTH(cell_id, psth_pattern, psth_label);
title(strcat(psth_pattern, " ", psth_label, " PSTH"), "Interpreter", "none");

% ISI
subplot(2, 3, 4)
plotISI(cell_id)
title('ISI');

% Temporal STA
subplot(2, 3, 5)
plotTSTAs(cell_id);
title('STA');

% Receptive Field
subplot(2, 3, [3, 6])
plotSSTA(cell_id);
title('Receptive Field');

% Title
supertitle = {  ['Cell #' num2str(cell_id) '. ' 'Type: ' char(cell_type)];
                ['Experiment: ' char(cell_exp) ', N = ' num2str(cell_N) '.']};
h = suptitle(supertitle);
h.Interpreter = 'none';
fullScreen();
