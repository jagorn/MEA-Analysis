function importDatasets()
fprintf('choose the datasets to import\n')
[files, path] = uigetfile('*.mat', 'Select Multiple Files', 'MultiSelect', 'on' );

if iscell(files)
    % multiple files were chosen
    for i_file = 1:numel(files)
        file = files{i_file};
        [~, dataset_id, ~] = fileparts(file);
        dataset_file = fullfile(path, file);
        importDataset(dataset_file, dataset_id);
    end
else
    % only one file was chosen
    [~, dataset_id, ~] = fileparts(files);
    dataset_file = fullfile(path, files);
    importDataset(dataset_file, dataset_id);
end
