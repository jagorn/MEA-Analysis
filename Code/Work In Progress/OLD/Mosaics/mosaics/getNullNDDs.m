function null_nnnds = getNullNDDs(n_cells, exp_id)

load(getDatasetMat, 'classesTableNotPruned');
load(getDatasetMat, 'nullNDDs');
if ~exist('nullNDDs', 'var')
    error('mosaics statistics have not been calculated for this dataset (run main_mosaicsStats to do so)')
end
i_exp = [experiments{:}] == exp_id;

if n_cells < 2
    null_nnnds = [];
else
    null_nnnds = nullNDDs{n_cells, i_exp};
end