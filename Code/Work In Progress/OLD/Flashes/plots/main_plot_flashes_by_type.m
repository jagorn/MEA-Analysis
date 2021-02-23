clear
close all

load(getDatasetMat(), 'cellsTable', 'classesTable')

for i_class = 1:numel(classesTable)
    cell_idx = find(classesTable(i_class).indices);
    
    plotFlashResponses(cell_idx, true);
    suptitle(classesTable(i_class).name);
    waitforbuttonpress();
    close
end