function copyDataset(dataset_id, copy_id)
dataset_id = char(dataset_id);
copy_id = char(copy_id);

dataset_manager = getDatasetManager();

if ~isKey(dataset_manager.datasets, dataset_id)
    error_struct.message = strcat("Dataset ", dataset_id, " does not exist.");
    error_struct.identifier = strcat('MEA_Analysis:', mfilename);
    error(error_struct);
end

if isKey(dataset_manager.datasets, copy_id)
    prompt = strcat("A dataset named ", copy_id, " exists already. Do you want to overwrite it? (y/n)\n");
    user_input = input(prompt, 's');
    if ~strcmp(user_input, 'y') && ~strcmp(user_input, 'Y')
        return;
    end
end

dataset_file = dataset_manager.datasets(dataset_id);

if ~isfile(dataset_file)
    error_struct.message = strcat("The file for dataset ", dataset_id, " was not found.");
    error_struct.identifier = strcat('MEA_Analysis:', mfilename);
    error(error_struct);
end

copy_file = fullfile(datasetsPath(), strcat(copy_id, '.mat'));
copyfile(dataset_file, copy_file)
dataset_manager.datasets(copy_id) = copy_file;
setDatasetManager(dataset_manager);
