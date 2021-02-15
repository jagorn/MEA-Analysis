function changeDataset(dataset_id)
dataset_id = char(dataset_id);
dataset_manager = getDatasetManager();


if ~isKey(dataset_manager.datasets, dataset_id)
    error_struct.message = strcat("Dataset ", dataset_id, " does not exist.");
    error_struct.identifier = strcat('MEA_Analysis:', mfilename);
    error(error_struct);
end

dataset_manager.active_dataset = dataset_id;
setDatasetManager(dataset_manager);



