function repetitions = getRepetitions(exp_id, section_id)
% returns the repetitions of all the the repeated sequences of a section in
% a given experiment.
%
% PARAMS:
% EXP_ID:           identifier of the experiment.
% SECTION_ID:       identifier of the section.
%
% OUTPUT:
% repetitions: a struct describing the structure of the stimulus.
%   repetitions.names{i}:           the name of the i-th repeated patterns of the stimulus
%   repetitions.rep_begins{i}:      an array indicating the first trigger of each repetition of the i-th pattern
%   repetitions.durations{i}:       the duration (in frames) of the i-th pattern

section_table = getSection(exp_id, section_id);
if ~isfield(section_table, 'repetitions')
    error_struct.message = strcat("repetitions of section ",  num2str(section_id), " not found in experiment ", exp_id);
    error_struct.identifier = strcat('MEA_Analysis:', mfilename);
    error(error_struct);
end
repetitions = section_table.repetitions;



