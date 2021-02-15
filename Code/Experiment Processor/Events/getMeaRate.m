function mea_rate = getMeaRate(exp_id)
evt_times_file = fullfile(processedPath(exp_id), 'EvtTimes.mat');
load(evt_times_file, 'mea_rate');

if ~exist('mea_rate', 'var')
    error_struct.message = strcat("mea rate have not been saved for ", exp_id);
    error_struct.identifier = strcat('MEA_Analysis:', mfilename);
    error(error_struct);  
end
    