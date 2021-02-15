function dataset_id = getDatasetId()

dataset_manager = getDatasetManager();

if isempty(dataset_manager.active_dataset)
    error_struct.message = strcat("There is no active dataset.");
    error_struct.identifier = strcat('MEA_Analysis:', mfilename);
    error(error_struct);
end

dataset_id = dataset_manager.active_dataset;


