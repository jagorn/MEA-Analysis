load(getDatasetMat, 'cellsTable', 'classesTable', 'experiments');

distance_thresh = 1;
area_thresh = 0.85;

n_cells = numel(cellsTable);
class_idx = [classesTable.name];
exp_idx = [experiments{:}];

duplicate_cells = boolean(zeros(1, n_cells));
for i_class = 1:length(class_idx)
    class_id = class_idx(i_class);

    for i_exp = 1:length(exp_idx)    
        exp_id = exp_idx(i_exp);
        
        idx = classExpIndices(class_id, exp_id);
        idx_duplicates = findDuplicateRFs(idx, distance_thresh, area_thresh);
        duplicate_cells = duplicate_cells | idx_duplicates;
    end
end
save(getDatasetMat, 'duplicate_cells', '-append');