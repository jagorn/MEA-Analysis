close all
clear
clc

rgc_label = "RGC";
cnn_label = "CNN";

changeDataset(cnn_label);
load(getDatasetMat, 'classesTableNotPruned', 'experiments');

class_ids = [classesTableNotPruned.name];
exp_ids = [experiments{:}];

i = 0;
for class_id = class_ids
    for exp_id = exp_ids
        idx = classExpIndices(class_id, exp_id);

        if(sum(idx) > 0)
            i = i + 1;

            modelsTable(i).class = class_id;
            modelsTable(i).experiment = exp_id;
            modelsTable(i).size = sum(idx);
            modelsTable(i).indices = idx;
        end
    end
end

[~, sorted_idx] = sort([modelsTable.class]);
modelsTable = modelsTable(sorted_idx);

changeDataset(rgc_label);
save(getDatasetMat, 'modelsTable', '-append');
