function listPatternProfiles()
% It prints the list off all the available pattern profiles

pattern_file = stimPath('patterns.mat');
if ~isfile(pattern_file)
    error_struct.message = strcat("no pattern profiles have not been found");
    error_struct.identifier = strcat('MEA_Analysis:', mfilename);
    error(error_struct);
end
C = who('-file', pattern_file);
fprintf('the stimulus pattern profiles saved are:\n')
for i_stim = 1:numel(C)
    fprintf("%i: %s\n", i_stim, C{i_stim})
end

