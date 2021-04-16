function removeAllActivations()

load(getDatasetMat, 'activations');
if ~exist('activations', 'var')
    error_struct.message = strcat(getDatasetId(), " has no activations computed yet");
    error_struct.identifier = strcat('MEA_Analysis:', mfilename);
    error(error_struct);
end

input_message = strcat("Are you sure you want to remove all activations from the dataset ", getDatasetId(), "? (y/n)\n");
user_input = input(input_message, 's');
if ~strcmp(user_input, 'y') && ~strcmp(user_input, 'Y')
    fprintf('activations have not been deleted\n')
    return;
end

clear
loadDataset();
clear activations;
save(getDatasetMat());

fprintf('all activations have been deleted\n')

