function plotInhibitionCard(cell_id)

% params
color_DH_DMD = [.99, .95, .75];
color_DMD = [.75, .95, .99];

% load Data
load(getDatasetMat, 'cellsTable', 'clustersTable');
cell_N = cellsTable(cell_id).N;
cell_exp = char(cellsTable(cell_id).experiment);
if exist('clustersTable', 'var')
    cell_type = clustersTable(cell_id).Type;
else
    cell_type = 'unknown';
end

figure('Name', ['Cell_#' num2str(cell_id)]);                

% rasters
plotDHRaster(cell_id, 'DMD_delayedbin', 'single', ...
                    'Is_Subfigure', true, ...
                    'Columns_Indices', [1,3], ...
                    'Dead_Times', false, ...
                    'N_Columns', 8, ...
                    'Stim_Color', color_DMD, ...
                    'Labels_Mode', 1, ...
                    'Time_Spacing', .5);
                
plotDHRaster(cell_id, 'DH_DMD_delayedbin', 'single', ...
                    'Is_Subfigure', true, ...
                    'Columns_Indices', [2,4], ...
                    'Dead_Times', false, ...
                    'N_Columns', 8, ...
                    'Stim_Color', color_DH_DMD, ...
                    'Labels_Mode', 1, ...
                    'Time_Spacing', .5);

% rasters legend   
subplot(4, 6, 4)
axis off
hold on
L(1) = scatter(nan, nan, 5, color_DMD, 'filled');
L(2) = scatter(nan, nan, 5, color_DH_DMD, 'filled');
legend(L, {'Visual Stim', 'Visual + DH Stim'},'FontSize', 12, 'Location', 'northeast')

% temporal sta
subplot(4, 6, 5)
plotTSTAs(cell_id)
title('Temporal STA')

% weights 
subplot(4, 6, [10 11 12 16 17 18 22 23 24])
plotInhibitionWeights(cell_id, 'DMD_delayedbin', 'DH_DMD_delayedbin', ...
                'Is_Subfigure', true, ...
                'Labels', true);
title('VISUAL - DH & VISUAL', 'Interpreter', 'None')

% title
supertitle = {  ['Cell #' num2str(cell_id) '. ' 'Type: ' char(cell_type) '. ' ...
                'Experiment: ' char(cell_exp) ', N = ' num2str(cell_N) '.']};
h = suptitle(supertitle);
h.Interpreter = 'none';
fullScreen();

% export and save
fig_path = [plotsPath() '/' getDatasetId() '/'];
fig_name = ['Inhibition_delayed_cell#' num2str(cell_id)];
export_fig([fig_path fig_name], '-png'),
close