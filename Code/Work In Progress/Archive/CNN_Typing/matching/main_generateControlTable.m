close all
clear
clc

rgc_label = "RGC";
control_label = "STA";

changeDataset(control_label);
load(getDatasetMat, 'classesTableNotPruned', 'experiments');

class_ids = [classesTableNotPruned.name];
exp_ids = [experiments{:}];

i = 0;
for class_id = class_ids
    for exp_id = exp_ids
        idx = classExpIndices(class_id, exp_id);

        if(sum(idx) > 0)
            i = i + 1;

            controlTable(i).class = class_id;
            controlTable(i).experiment = exp_id;
            controlTable(i).size = sum(idx);
            controlTable(i).indices = idx;
        end
    end
end

[~, sorted_idx] = sort([controlTable.class]);
controlTable = controlTable(sorted_idx);

changeDataset(rgc_label);
save(getDatasetMat, 'controlTable', '-append');
