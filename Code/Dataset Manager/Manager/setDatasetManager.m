function setDatasetManager(dataset_manager)

dataset_manager_file = fullfile(datasetsPath(), '__DatasetManager__.mat');
save(dataset_manager_file,  'dataset_manager');

