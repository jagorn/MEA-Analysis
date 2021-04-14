function removeAllDatasetPSTHs()

load(getDatasetMat, 'psths');
if ~exist('psths', 'var')
    error_struct.message = strcat(getDatasetId(), " has no psths yet");
    error_struct.identifier = strcat('MEA_Analysis:', mfilename);
    error(error_struct);
end

input_message = strcat("Are you sure you want to remove all psths from the dataset ", getDatasetId(), "? (y/n)\n");
user_input = input(input_message, 's');
if ~strcmp(user_input, 'y') && ~strcmp(user_input, 'Y')
    fprintf('psths have not been deleted\n')
    return;
end

clear
loadDataset();
clear psths;
save(getDatasetMat());

fprintf('all psths have been deleted\n')

