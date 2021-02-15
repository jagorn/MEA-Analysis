function section_table = getSection(exp_id, section_id)
sections_table = getSectionsTable(exp_id);

if ischar(section_id) || isstring(section_id)
    i_section = find([sections_table.id] == section_id);
    
elseif islogical(section_id)
    i_section = find(section_id);
    
else
    i_section = section_id;
end

if (numel(i_section) ~= 1) || isinf(i_section) || floor(i_section) ~= i_section
    error_struct.message = strcat("section ",  num2str(section_id), " not found in experiment ", exp_id);
    error_struct.identifier = strcat('MEA_Analysis:', mfilename);
    error(error_struct);
end
section_table = sections_table(i_section);


