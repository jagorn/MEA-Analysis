function checkSpikeInDeadTimes(dead_times, SpikeTimes)


% Iterate over cells (spike trains)
for i_train = 1:numel(SpikeTimes)
    fprintf("\nCELL #%d\n", i_train)
    spike_train = SpikeTimes{i_train}(:).';
    n_spikes_in_dead_times = 0;
    
    % Iterate over dead times
    for i_dt = 1:size(dead_times,1)
        dead_init = dead_times(i_dt,1);
        dead_end = dead_times(i_dt,2);
        
        % Iterate over spikes
        for spike_time = spike_train
            if (spike_time > dead_init) && (spike_time < dead_end)
                n_spikes_in_dead_times = n_spikes_in_dead_times + 1;
%                 fprintf("\t\tspike t=%d is inside the window [%d, %d]\n", spike_time, dead_init, dead_end)
            end
        end
    end
    fprintf("\tspikes in dead times are %d out of %d\n", n_spikes_in_dead_times, numel(spike_train))
end
