function initializeDatasetManager()

dataset_manager_file = fullfile(datasetsPath(), '__DatasetManager__.mat');
dataset_manager.datasets = containers.Map;
dataset_manager.active_dataset = [];

if isfile(dataset_manager_file)
    warning("the dataset structure is already initialized");
else
    save(dataset_manager_file,  'dataset_manager');
end
