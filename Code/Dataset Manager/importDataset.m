function importDataset(dataset_file, dataset_id)
dataset_file = char(dataset_file);
dataset_id = char(dataset_id);

dataset_manager = getDatasetManager();

if ~isfile(dataset_file)
    error_struct.message = strcat("Dataset ", dataset_file, " does not exist.");
    error_struct.identifier = strcat('MEA_Analysis:', mfilename);
    error(error_struct);
end

overwrite = false;
while isKey(dataset_manager.datasets, dataset_id) && ~overwrite
    prompt = strcat("A dataset named ", dataset_id, " exists already. Do you want to overwrite it? (y/n)\n");
    user_input = input(prompt, 's');
    if strcmp(user_input, 'y') || strcmp(user_input, 'Y')
        overwrite = true;
    else
        prompt = strcat("Choose a new dataset name for ", dataset_file, "\n");
        dataset_id = input(prompt, 's');
    end
end

copy_file = fullfile(datasetsPath(), strcat(dataset_id, '.mat'));
copyfile(dataset_file, copy_file)
dataset_manager.datasets(dataset_id) = copy_file;
setDatasetManager(dataset_manager);

fprintf("Dataset %s imported as %s\n", dataset_file, dataset_id);


