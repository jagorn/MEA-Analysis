function [x, y] = raster(spikes, onsets, offsets, sampling_rate)
% generates x and y coordinates of a raster representing the spike times of
% a group of cell in response to a given stimulus.
%
% PARAMETERS:
% spikes:           the spike times of a set of cells
% onsets, offsets:  the beginning and ending of each of the stimulus repetitions
% sampling_rate:    the sampling rate of the recordings

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
