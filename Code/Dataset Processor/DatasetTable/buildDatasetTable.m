function cellsTable = buildDatasetTable(expIds, cellsIds, grades)
% expIds = a cell array containing the ids of each experiment (strings)
% expTraces = a struct containing the traces for each experiment {n_exp x [n_cell x n_step]}

cellsTable = {};
cellCount = 1;

for iExp = 1:numel(expIds)
    
    expId = expIds{iExp};
    ids = cellsIds{iExp};
    
    for n = 1:size(ids,1)
        cellsTable(cellCount).experiment = string(expId);
        cellsTable(cellCount).N = ids(n);
        cellsTable(cellCount).Grade = grades(n);
        cellCount = cellCount + 1;
        n = n + 1;
    end
end

