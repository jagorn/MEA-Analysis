% Paths
exp_id = '20191011_grid';

exp_folder = [dataPath() '/' exp_id '/'];
processed_folder = [exp_folder 'processed/'];

spikes_file = [processed_folder  'muaSpikeTimesCorrupted.mat'];
dead_times_file = [exp_folder 'sorted/dead_times.txt'];

% Load
load(spikes_file, 'spike_times', 'spike_times_dt');
load(dead_times_file);

% Do
figure()
hold on

for i_channel = mea_channels
    spikes = spike_times{i_channel};
    scatter(spikes, ones(numel(spikes), 1)*i_channel, '.')
end


for dtime = dead_times'
    xline(dtime(1),'g');
    xline(dtime(2),'r');
end