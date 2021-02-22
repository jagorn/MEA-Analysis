function frame_activation(spike_times, evt_times, order_frames, mea_rate)

cells_indices = 1:numel(spike_times);

order_frames = order_frames(1:numel(evt_times));
frame_ids = uniques(order_frames);

for frame_id = frame_ids 
    frame_times = evt_times(order_frames == frame_id);
    [psth, ~, ~, ~, ~] = doPSTH(spike_times, frame_times, bin_size, n_bins,  mea_rate, cells_indices);
end

