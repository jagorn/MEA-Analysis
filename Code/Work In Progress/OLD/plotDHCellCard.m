function plotDHCellCard(cell_id, session_label, varargin)


% Default Parameters
model_label_default = [];
with_labels_default = false;
do_print_default = false;

% Parse Input
p = inputParser;
addRequired(p, 'i_cell');
addRequired(p, 'session_label');
addParameter(p, 'Model', model_label_default);
addParameter(p, 'Labels', with_labels_default, @islogical);
addParameter(p, 'Print', do_print_default);

parse(p, cell_id, session_label, varargin{:}); 
model_label = p.Results.Model; 
with_labels = p.Results.Labels; 
do_print = p.Results.Print; 


load(getDatasetMat, 'cellsTable', 'clustersTable');

cell_N = cellsTable(cell_id).N;
cell_exp = char(cellsTable(cell_id).experiment);
if exist('clustersTable', 'var')
    cell_type = clustersTable(cell_id).Type;
else
    cell_type = 'unknown';
end

figure('Name', ['Cell_#' num2str(cell_id)]);

subplot(2, 3, 1)
plotISICell(cell_id)
title('ISI');

subplot(2, 3, 4)
plotTSTAs(cell_id);
title('STA');

subplot(2, 3, [2, 3, 5, 6])
plotDHWeights(  cell_id, session_label, ...
                'Model', model_label, ...
                'Is_Subfigure', true, ...
                'Labels', with_labels);

supertitle = {  ['Cell #' num2str(cell_id) '. ' 'Type: ' char(cell_type) '. ' ...
                'Experiment: ' char(cell_exp) ', N = ' num2str(cell_N) '.']};
            
h = suptitle(supertitle);
h.Interpreter = 'none';
fullScreen();

if do_print
    fig_path = [plotsPath() '/' getDatasetId() '/'];
    fig_name = [session_label '_cell#' num2str(cell_id)];
    export_fig([fig_path fig_name], '-png'),
    close
end