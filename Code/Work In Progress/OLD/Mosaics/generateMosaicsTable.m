close all
clear
clc

load(getDatasetMat, 'mosaicPValues');
load(getDatasetMat, 'classesTableNotPruned', 'experiments');

alfa = 0.05;
min_size = 5;

classes = [classesTableNotPruned.name];
experiments = [experiments{:}];

[idx_classes, idx_exps] = find(mosaicPValues <= alfa);

class_ids = classes(idx_classes);
exp_ids = experiments(idx_exps);
p_values = diag(mosaicPValues(idx_classes, idx_exps));

for i = 1:length(class_ids)
    idx = classExpIndices(class_ids(i), exp_ids(i));

    mosaicsTable(i).class = class_ids(i);
    mosaicsTable(i).experiment = exp_ids(i);
    mosaicsTable(i).p_val = p_values(i);
    mosaicsTable(i).size = sum(idx);
    mosaicsTable(i).indices = idx;
end

mosaicsTable = mosaicsTable([mosaicsTable.size] >= min_size);
[~, sorted_idx] = sort([mosaicsTable.class]);
mosaicsTable = mosaicsTable(sorted_idx);

save(getDatasetMat, 'mosaicsTable', '-append');
