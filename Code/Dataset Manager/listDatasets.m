function listDatasets()

dataset_manager = getDatasetManager();

if isempty(dataset_manager.datasets.keys())
    fprintf("No dataset available\n");
end

dataset_ids = dataset_manager.datasets.keys();
for i = 1:numel(dataset_ids)
    fprintf("\t%i. %s\n", i, dataset_ids{i});
end
fprintf("\n");


