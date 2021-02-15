function createDataset(dataset_id, experiments, cellsTable, spikes, mea_rate)
dataset_id = char(dataset_id);
dataset_manager = getDatasetManager();

if isKey(dataset_manager.datasets, dataset_id)
    prompt = strcat("a dataset named ", dataset_id, " exists alredy. Do you want to overwrite it? (y/n)\n");
    user_input = input(prompt, 's');
    if ~strcmp(user_input, 'y') && ~strcmp(user_input, 'Y')
        disp('the dataset has not been overwritten');
        return;
    end
end

dataset_file = fullfile(datasetsPath(), strcat(dataset_id, '.mat'));
save(dataset_file, 'experiments', 'cellsTable', 'spikes', 'mea_rate');
dataset_manager.datasets(dataset_id) = dataset_file;
dataset_manager.active_dataset = dataset_id;
setDatasetManager(dataset_manager);
