function removeActivations(pattern_label, psth_label, activation)

load(getDatasetMat, 'activations');
if ~exist('activations', 'var')
    error_struct.message = strcat(getDatasetId(), " has no activations computed yet");
    error_struct.identifier = strcat('MEA_Analysis:', mfilename);
    error(error_struct);
end

if ~isfield(activations, pattern_label) || ~isfield(activations.(pattern_label), psth_label) || ~isfield(activations.(pattern_label).(psth_label), activation)
    error_struct.message = strcat(getDatasetId(), " has no activations ", activation, " for ", pattern_label, ".", psth_label);
    error_struct.identifier = strcat('MEA_Analysis:', mfilename);
    error(error_struct);
end

input_message = strcat("Are you sure you want to remove activations ", activation, " for the pattern ",  pattern_label, ".", psth_label, " from the dataset ", getDatasetId(), "? (y/n)\n");
user_input = input(input_message, 's');
if ~strcmp(user_input, 'y') && ~strcmp(user_input, 'Y')
    fprintf('activations have not been deleted\n')
    return;
end



activations.(pattern_label).(psth_label) = rmfield(activations.(pattern_label).(psth_label), activation);


if isempty(fields(activations.(pattern_label).(psth_label)))
    activations.(pattern_label) = rmfield(activations.(pattern_label), psth_label);
end
if isempty(fields(activations.(pattern_label)))
    activations = rmfield(activations, pattern_label);
end

save(getDatasetMat, 'activations', '-append')
fprintf('activations have been succesfully deleted\n')

