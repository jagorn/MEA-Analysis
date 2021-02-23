old_name = "20170614";
new_name = "20170614_noDH";

load(getDatasetMat(), "cellsTable", "clustersTable", "experiments");

experiments_ids = find([experiments{:}] == old_name);
for i_e = experiments_ids
    experiments{i_e} = new_name;
end

cells_ids = find([cellsTable.experiment] == old_name);
for i_c = cells_ids
    cellsTable(i_c).experiment = new_name;
end

clusters_ids = find([clustersTable.Experiment] == old_name);
for i_t = clusters_ids
    clustersTable(i_t).Experiment = new_name;
end

save(getDatasetMat(), "cellsTable", "clustersTable", "experiments", "-append");

clear
loadDataset


