function mua_spikes = readMUASpikeTimes(results_file, mea_channels)

% load the spike times
spikes_dataset = '/spiketimes';
results_info = h5info(results_file, spikes_dataset);

n_channels = numel(results_info.Datasets);
assert(n_channels == numel(mea_channels))

fprintf('Extracting Traces...\n');
mua_spikes = cell(n_channels, 1);
for i_channel = 1:n_channels
    
    mea_id = mea_channels(i_channel);
    dataset_id = ['elec_' num2str(i_channel - 1)];
    
    spikes = h5read(char(results_file), [spikes_dataset '/' dataset_id]);
    mua_spikes{mea_id}  = double(spikes(:));
    fprintf('\tsaving %s in mea channel %d\n', dataset_id, mea_id);
end
fprintf('Extraction Completed\n\n');
