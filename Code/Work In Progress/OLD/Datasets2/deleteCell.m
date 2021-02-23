function deleteCell(i_cell)

str = input(['entry ' num2str(i_cell) ' will be permanently deleted from dataset ' char(getDatasetId() ) '\nare you sure? (y/n)\n'],'s');
if strcmp(str, 'y') || strcmp(str, 'Y')
    
    loadDataset();
    cellsTable(i_cell) = [];
    psths(i_cell) = [];
    spatialSTAs(i_cell) = [];
    spikes(i_cell) = [];
    stas(i_cell) = [];
    temporalSTAs(i_cell, :) = [];
    tracesMat(i_cell, :) = [];
    
    clear str i_cell
    save(getDatasetMat());

    fprintf('entry succesfully deleted\n')
else
    fprintf('operation cancelled')
end
