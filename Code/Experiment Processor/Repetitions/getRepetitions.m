function repetitions = getRepetitions(exp_id, section_id)
section_table = getSection(exp_id, section_id);

if ~isfield(section_table, 'repetitions')
    error_struct.message = strcat("repetitions of section ",  num2str(section_id), " not found in experiment ", exp_id);
    error_struct.identifier = strcat('MEA_Analysis:', mfilename);
    error(error_struct);
end
repetitions = section_table.repetitions;



