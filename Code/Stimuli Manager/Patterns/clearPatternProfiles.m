function clearPatternProfiles()
% It deletes all the temporal profiles saved
pattern_file = stimPath('patterns.mat');

if ~isfile(pattern_file)
    error_struct.message = strcat("there is no stimulus profile stored.");
    error_struct.identifier = strcat('MEA_Analysis:', mfilename);
    error(error_struct);
end

input_message = strcat("Are you sure you want to clear all pattern profiles? (y/n)\n");
user_input = input(input_message, 's');
if ~strcmp(user_input, 'y') && ~strcmp(user_input, 'Y')
    fprintf('pattern profiles have not been deleted\n')
    return;
end

delete(pattern_file)
fprintf('all pattern profiles have been deleted\n')

