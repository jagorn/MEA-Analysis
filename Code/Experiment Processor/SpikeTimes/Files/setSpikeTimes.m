function setSpikeTimes(exp_id, spikes)
spiketimes_file = fullfile(processedPath(exp_id), 'SpikeTimes.mat');
save(spiketimes_file, 'spikes');
