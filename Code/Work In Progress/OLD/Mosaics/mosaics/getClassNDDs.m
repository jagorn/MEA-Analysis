function [ndds, null_ndds] = getClassNDDs(class_id, exp_id)

load(getDatasetMat, 'classesTableNotPruned', 'experiments');
load(getDatasetMat, 'mosaicNDDs', 'nullNDDs');
if ~exist('mosaicNDDs', 'var') ||  ~exist('nullNDDs', 'var')
    error('mosaics statistics have not been calculated for this dataset (run main_mosaicsStats to do so)')
end

% load the mosaic statistics for [class_id] in [exp_id]
if  not(endsWith(class_id, "."))
    class_id = strcat(class_id, ".");
end
i_class = [classesTableNotPruned.name] == class_id;
i_exp = [experiments{:}] == exp_id;

ndds = mosaicNDDs{i_class, i_exp};
if isempty(ndds)
    null_ndds = [];
else
    null_ndds = nullNDDs{length(ndds), i_exp};
end
