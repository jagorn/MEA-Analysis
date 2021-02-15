function dataset_file = getDatasetMat()

dataset_manager = getDatasetManager();

if isempty(dataset_manager.active_dataset)
    error_struct.message = strcat("There is no active dataset.");
    error_struct.identifier = strcat('MEA_Analysis:', mfilename);
    error(error_struct);
end

dataset_id = dataset_manager.active_dataset;
dataset_file = dataset_manager.datasets(dataset_id);

if ~isfile(dataset_file)
    error_struct.message = strcat("The file for dataset ", dataset_id, " was not found.");
    error_struct.identifier = strcat('MEA_Analysis:', mfilename);
    error(error_struct);
end

