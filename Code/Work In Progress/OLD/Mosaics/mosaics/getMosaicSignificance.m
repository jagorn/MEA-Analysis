function [h, p] = getMosaicSignificance(class_id, exp_id)

load(getDatasetMat, 'classesTableNotPruned', 'experiments');
load(getDatasetMat, 'mosaicSignificances', 'mosaicPValues');
if ~exist('mosaicSignificances', 'var') ||  ~exist('mosaicPValues', 'var')
    error('mosaics significance have not been assessed for this dataset (run main_mosaicsSignificance to do so)')
end

% load the mosaic statistics for [class_id] in [exp_id]
if  not(endsWith(class_id, "."))
    class_id = strcat(class_id, ".");
end
i_class = [classesTableNotPruned.name] == class_id;
i_exp = [experiments{:}] == exp_id;

h = mosaicSignificances(i_class, i_exp);
p = mosaicPValues(i_class, i_exp);
