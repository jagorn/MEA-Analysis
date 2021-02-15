function spike_trains = extractSpikeTrains(spikes, initial_times, ending_times, spike_time_offsets)
% computes the [i] arrays of spike_times
% lying in the intervals <initial_time_i, ending_time_i>
% and subtracts spike_time_offsets_i from each spike array

assert(size(spikes, 1) == 1);
assert(size(initial_times, 1) == 1);
assert(size(ending_times, 1) == 1);
assert(size(initial_times, 2) == size(ending_times, 2));
assert(size(initial_times, 2) == size(ending_times, 2));
assert(all(initial_times < ending_times))

if exist('spike_time_offsets', 'var')
    assert(size(spike_time_offsets, 1) == 1);
    assert(size(initial_times, 2) == size(spike_time_offsets, 2));
else
    spike_time_offsets = initial_times;
end

n_windows = size(initial_times, 2);

% build 2D truth matrix [n_spikes * n_windows]
% asserting weather a spike is in a given time window
is_spike_in_window = (spikes.' > initial_times) & (spikes.' < ending_times);

% build spike trains
spike_trains = cell(1, n_windows);
for i = 1:n_windows
    spike_trains{i} = spikes(is_spike_in_window(:, i)) - spike_time_offsets(i);
end

