
exp_id = '20191011_grid';

% Input Paths
mua_file = ['/home/fran_tr/Data/' exp_id '/sorted/CONVERTED/CONVERTED.mua.hdf5'];
mea_channels = [1:126, 129:254]; % excluded trigger electrodes

% Output Paths
spikes_file = 'muaSpikeTimes.mat';
spikes_folder = [dataPath(), '/', exp_id, '/processed/'];

% Do
spike_times = readMUASpikeTimes(mua_file, mea_channels);

% Save
save([tmpPath '/' spikes_file], 'spike_times');
movefile([tmpPath '/' spikes_file], spikes_folder);