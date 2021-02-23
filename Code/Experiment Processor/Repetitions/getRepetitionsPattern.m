function [repetitions, duration] = getRepetitionsPattern(exp_id, section_id, pattern)
% returns the repetitions of a specific pattern in a section of
% a given experiment.
%
% PARAMS:
% EXP_ID:           identifier of the experiment.
% SECTION_ID:       identifier of the section.
% PATTERN:          identifier of the repeated pattern
%
% OUTPUT:
% repetitions:      an array indicating the first trigger of each repetition of the pattern
% duration:         the duration (in frames) of the pattern
repetitions_struct = getRepetitions(exp_id, section_id);
idx = strcmp(repetitions_struct.names, pattern);

if ~any(idx)
    error_struct.message = strcat("repetitions of section ",  num2str(section_id), " pattern ", pattern, " not found in experiment ", exp_id);
    error_struct.identifier = strcat('MEA_Analysis:', mfilename);
    error(error_struct);
end

repetitions = repetitions_struct.rep_begins{idx};
duration = repetitions_struct.durations{idx};


