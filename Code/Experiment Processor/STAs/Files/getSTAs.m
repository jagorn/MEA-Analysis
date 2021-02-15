function STAs = getSTAs(exp_id)
stas_file = getSTAsFile(exp_id);
load(stas_file, 'STAs');

if ~exist('STAs', 'var')
    error_struct.message = strcat("STAs were not generated yet in ", exp_id);
    error_struct.identifier = strcat('MEA_Analysis:', mfilename);
    error(error_struct);  
end
    
