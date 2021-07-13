function [section_table , i_section] = getHoloSection(exp_id, section_id)
% Returns a struct representing an holography section.
%
% PARAMETERS:
% EXP_ID:                               the identifier of the experiment.
% SECTION_ID:                              the identifier of the section.

% OUTPUT:
% A struct describing the section, specifying the stimulus used,
% conditions, triggers, repetitions, frame rate, etc...

sections_table = getHolographyTable(exp_id);

if ischar(section_id) || isstring(section_id)
    i_section = find(strcmp({sections_table.id}, section_id));
    
elseif islogical(section_id)
    i_section = find(section_id);
    
else
    i_section = section_id;
end

if (numel(i_section) ~= 1) || isinf(i_section) || floor(i_section) ~= i_section
    error_struct.message = strcat("holography section ",  num2str(section_id), " not found in experiment ", exp_id);
    error_struct.identifier = strcat('MEA_Analysis:', mfilename);
    error(error_struct);
end
section_table = sections_table(i_section);


