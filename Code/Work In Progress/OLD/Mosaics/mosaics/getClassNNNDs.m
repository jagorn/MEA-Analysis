function [nnnds, null_nnnds] = getClassNNNDs(class_id, exp_id)

load(getDatasetMat, 'classesTableNotPruned', 'experiments');
load(getDatasetMat, 'mosaicNNNDs', 'nullNNNDs');
if ~exist('mosaicNNNDs', 'var') ||  ~exist('nullNNNDs', 'var')
    error('mosaics statistics have not been calculated for this dataset (run main_mosaicsStats to do so)')
end

% load the mosaic statistics for [class_id] in [exp_id]
if  not(endsWith(class_id, "."))
    class_id = strcat(class_id, ".");
end
i_class = [classesTableNotPruned.name] == class_id;
i_exp = [experiments{:}] == exp_id;

nnnds = mosaicNNNDs{i_class, i_exp};
if isempty(nnnds)
    null_nnnds = [];
else
    null_nnnds = nullNNNDs{length(nnnds), i_exp};
end
