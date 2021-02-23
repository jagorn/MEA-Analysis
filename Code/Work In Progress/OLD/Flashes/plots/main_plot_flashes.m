clear
close all

pace = 5;
load(getDatasetMat(), 'cellsTable', 'classesTable')


% which cells to show?

% all cells
% cell_idx = 1:numel(cellsTable);

% only off
cell_idx = find([cellsTable.POLARITY] == 'ON');

% only chosen ones
% cell_idx = [14 15 16 17];
% cell_idx =  [    12    19    35    42    48 68]

for i = 1:pace:(numel(cell_idx))
    ii = i:min(i+pace-1, numel(cell_idx));
    ii_cells = cell_idx(ii);
    plotFlashResponses(ii_cells, true);
    waitforbuttonpress();
    close
end