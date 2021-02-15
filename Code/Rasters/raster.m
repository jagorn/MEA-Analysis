function [x, y] = raster(spikes, onsets, offsets, sampling_rate)

assert(length(onsets) == length(offsets))
n_reps = length(onsets);

x = [];
y = [];

for r = 1:n_reps

    spikes_segment = and(spikes > onsets(r), spikes < offsets(r));
    spikes_rep = (spikes(spikes_segment) - onsets(r)) / sampling_rate;
    row_rep = ones(length(spikes_rep), 1) * r;
    
    
    x = [x; spikes_rep];
    y = [y; row_rep];
end
