function dhTimes = getDHTimes(exp_id)
evt_times_file = fullfile(processedPath(exp_id), 'DHTimes.mat');
load(evt_times_file, 'dhTimes');

if ~exist('dhTimes', 'var')
    error_struct.message = strcat("dh times have not been extracted yet in ", exp_id);
    error_struct.identifier = strcat('MEA_Analysis:', mfilename);
    error(error_struct);  
end
    