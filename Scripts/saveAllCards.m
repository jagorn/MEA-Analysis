psth_pattern = 'euler';
psth_label = 'simple';

loadDataset();
n_cells = numel(cellsTable);

for i_cell = 1:n_cells
    plotCellCard(i_cell, psth_pattern, psth_label)
    export_fig(strcat("Cell#", num2str(i_cell), '.png'));
    close();
end