clear
close all

load(getDatasetMat(), 'cellsTable');

for i = 1:numel(cellsTable)
    cell_N = cellsTable(i).N;
    
    plotSingleCell(i)
    
    saveas(gcf, ['Ulisse_cell#' num2str(cell_N)],'jpg')
    close;
end