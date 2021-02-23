function plotControlCard(cell_id, session_label)

% params
color_normal = [.75, .95, .99];
color_BLOCK = [.99, .75, .95];

session_label = char(session_label);
session_control_label = [session_label '_BLOCK'];

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
plotDHRaster(cell_id, session_label, 'single', ...
                    'Is_Subfigure', true, ...
                    'Columns_Indices', [1,3], ...
                    'Dead_Times', false, ...
                    'N_Columns', 5, ...
                    'Stim_Color', color_normal, ...
                    'Labels_Mode', 1, ...
                    'Time_Spacing', 0.5);
                
plotDHRaster(cell_id, session_control_label, 'single', ...
                    'Is_Subfigure', true, ...
                    'Columns_Indices', [2,4], ...
                    'Dead_Times', false, ...
                    'N_Columns', 5, ...
                    'Stim_Color', color_BLOCK, ...
                    'Labels_Mode', 1, ...
                    'Time_Spacing', 0.5);

% rasters legend   
subplot(3, 5, 5)
axis off
hold on
L(1) = scatter(nan, nan, 5, color_normal, 'filled');
L(2) = scatter(nan, nan, 5, color_BLOCK, 'filled');
legend(L, {session_label, session_control_label},'FontSize', 12, 'Location', 'east', 'Interpreter', 'None')


% temporal sta
subplot(3, 5, 10)
plotTSTAs(cell_id)
title('Temporal STA')


% title
supertitle = {  ['Cell #' num2str(cell_id) ' ' 'Type: ' char(cell_type) '. ' ...
                'Experiment: ' char(cell_exp) ', N = ' num2str(cell_N) '.']};
h = suptitle(supertitle);
h.Interpreter = 'none';
fullScreen();

% export and save
fig_path = [plotsPath() '/' getDatasetId() '/'];
fig_name = ['Control_' session_label '_cell#' num2str(cell_id)];
export_fig([fig_path fig_name], '-png'),
close