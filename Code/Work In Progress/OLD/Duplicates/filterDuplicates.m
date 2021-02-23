function [idx_uniques, idx_duplicates] = filterDuplicates(idx)

load(getDatasetMat, 'duplicate_cells');
if ~exist('duplicate_cells', 'var')
    error('Duplicates have not been identified in this dataset (run main_findDuplicates to do so)')
end

idx_uniques = idx & ~duplicate_cells;
idx_duplicates = idx & duplicate_cells;



