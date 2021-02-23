function spike_times_filtered = applyDeadTimes(spike_times, dead_times)

spike_times_filtered = cell(size(spike_times));
for i_channel = 1:numel(spike_times)   
    spike_train = spike_times{i_channel};
    is_excluded = boolean(zeros(size(spike_train)));
    for i_spike = 1:length(spike_train)
        spike = spike_train(i_spike);
        is_excluded(i_spike) = any(and(spike > dead_times(:, 1), spike < dead_times(:, 2)));
    end
    spike_times_filtered{i_channel} = spike_train(~is_excluded);
end


