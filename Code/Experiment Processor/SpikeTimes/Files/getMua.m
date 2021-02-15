function mua = getMua(exp_id)
mua_file = fullfile(processedPath(exp_id), 'SpikeTimes_MultiUnit.mat');
load(mua_file, 'mua');

if ~exist('mua', 'var')
    error_struct.message = strcat("multi unit responses were not generated yet in ", exp_id);
    error_struct.identifier = strcat('MEA_Analysis:', mfilename);
    error(error_struct);  
end
    
