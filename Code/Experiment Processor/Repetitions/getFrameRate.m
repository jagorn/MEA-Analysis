function rate = getFrameRate(exp_id, section_id)
section_table = getSection(exp_id, section_id);

if ~isfield(section_table, 'rate')
    error_struct.message = strcat("frame rate of section ",  num2str(section_id), " not found in experiment ", exp_id);
    error_struct.identifier = strcat('MEA_Analysis:', mfilename);
    error(error_struct);
end
rate = section_table.rate;



