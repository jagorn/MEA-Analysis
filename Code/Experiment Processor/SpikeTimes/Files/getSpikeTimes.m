function spikes = getSpikeTimes(exp_id)
spiketimes_file = fullfile(processedPath(exp_id), 'SpikeTimes.mat');


if ~isfile(spiketimes_file)
    error_struct.message = strcat("sorted responses were not generated yet in ", exp_id);
    error_struct.identifier = strcat('MEA_Analysis:', mfilename);
    error(error_struct);  
end

load(spiketimes_file, 'spikes');

if ~exist('spikes', 'var')
    error_struct.message = strcat("sorted responses were not generated yet in ", exp_id);
    error_struct.identifier = strcat('MEA_Analysis:', mfilename);
    error(error_struct);  
end
    
