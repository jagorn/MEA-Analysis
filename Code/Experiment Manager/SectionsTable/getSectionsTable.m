function sectionsTable = getSectionsTable(exp_id)
stim_table_file = fullfile(processedPath(exp_id), 'SectionsTable.mat');

try
    load(stim_table_file, 'sectionsTable');
catch
    error_struct.message = strcat("sectionsTable was not generated yet in ", exp_id);
    error_struct.identifier = strcat('MEA_Analysis:', mfilename);
    error(error_struct);  
end

if ~exist('sectionsTable', 'var')
    error_struct.message = strcat("sectionsTable was not generated yet in ", exp_id);
    error_struct.identifier = strcat('MEA_Analysis:', mfilename);
    error(error_struct);  
end
    
