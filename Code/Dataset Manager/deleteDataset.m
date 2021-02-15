function deleteDataset(dataset_id)
dataset_id = char(dataset_id);
dataset_manager = getDatasetManager();

if ~isKey(dataset_manager.datasets, dataset_id)
    error_struct.message = strcat("Dataset ", dataset_id, " does not exists.");
    error_struct.identifier = strcat('MEA_Analysis:', mfilename);
    error(error_struct);
end

dataset_file = dataset_manager.datasets(dataset_id);

if ~isfile(dataset_file)
    message = strcat("The file for dataset ", dataset_id, " was not found.");
    warning(message);
end

prompt = strcat("Are you sure you want to delete dataset ", dataset_id, "? (y/n)\n");
user_input = input(prompt, 's');
if ~strcmp(user_input, 'y') && ~strcmp(user_input, 'Y')
    return;
end
    
delete(dataset_file);
remove(dataset_manager.datasets, dataset_id);
fprintf('Dataset %s has been deleted\n', dataset_id);
if strcmp(dataset_manager.active_dataset, dataset_id)
    dataset_manager.active_dataset = [];
end
setDatasetManager(dataset_manager);



