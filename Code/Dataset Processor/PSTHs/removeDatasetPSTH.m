function removeDatasetPSTH(label)
% removes the psth with the given label (or pattern, or name) from the
% dataset.

load(getDatasetMat, 'psths');
if ~exist('psths', 'var')
    error_struct.message = strcat(getDatasetId(), " has no psths yet");
    error_struct.identifier = strcat('MEA_Analysis:', mfilename);
    error(error_struct);
end

if ~isfield(psths, label)
    error_struct.message = strcat(getDatasetId(), " has no psth called ", label);
    error_struct.identifier = strcat('MEA_Analysis:', mfilename);
    error(error_struct);
end

input_message = strcat("Are you sure you want to remove the psth ", label, " from the dataset ", getDatasetId(), "? (y/n)\n");
user_input = input(input_message, 's');
if ~strcmp(user_input, 'y') && ~strcmp(user_input, 'Y')
    fprintf('the psth has not been deleted\n')
    return;
end

psths = rmfield(psths,label);
save(getDatasetMat, 'psths', '-append');
fprintf('the psth has been deleted\n')

