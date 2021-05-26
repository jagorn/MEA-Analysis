function repetitions = getHolographyRepetitions(exp_id, section_id)
% returns the repetitions of all the the holographic sections in a given experiment.
%
% PARAMS:
% EXP_ID:           identifier of the experiment.
% SECTION_ID:       identifier of the section.
%
% OUTPUT:
% repetitions: a struct describing the structure of the stimulus.
section_table = getHolographySection(exp_id, section_id);
if ~isfield(section_table, 'repetitions')
    error_struct.message = strcat("repetitions of holographic section ",  num2str(section_id), " not found in experiment ", exp_id);
    error_struct.identifier = strcat('MEA_Analysis:', mfilename);
    error(error_struct);
end
repetitions = section_table.repetitions;



