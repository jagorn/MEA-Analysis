function evtTimes = getEvtTimes(exp_id)
evt_times_file = fullfile(processedPath(exp_id), 'EvtTimes.mat');
load(evt_times_file, 'evtTimes');

if ~exist('evtTimes', 'var')
    error_struct.message = strcat("event times have not been extracted yet in ", exp_id);
    error_struct.identifier = strcat('MEA_Analysis:', mfilename);
    error(error_struct);  
end
    