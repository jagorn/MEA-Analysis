function dataset_manager = getDatasetManager()

dataset_manager_file = fullfile(datasetsPath(), '__DatasetManager__.mat');

try
    load(dataset_manager_file,  'dataset_manager');
catch
    warning("No dataset found. Initializing dataset manager...")
    initializeDatasetManager();
    load(dataset_manager_file,  'dataset_manager');
end
