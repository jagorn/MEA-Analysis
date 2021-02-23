
% Paths
exp_id = '20191011_grid';
exp_folder = [dataPath() '/' exp_id '/'];
processed_folder = [exp_folder 'processed/'];
dead_times_file = [exp_folder 'sorted/dead_times.txt'];

spikes_file = [processed_folder  'muaSpikeTimes.mat'];

% Load
load(spikes_file, 'spike_times');
load(dead_times_file);

spike_times_dt = applyDeadTimes(spike_times, dead_times);
save([tmpPath '/' 'muaSpikeTimes.mat'], 'spike_times', 'spike_times_dt');
movefile([tmpPath '/' 'muaSpikeTimes.mat'], processed_folder);
