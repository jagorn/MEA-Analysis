function [psth, xpsth, mean_psth, firing_rates] = doPSTH(spikes, repetitions, bin_size, n_bins,  sampling_rate, cells_indices)
% Implentation of simple binned PSTH (see page 14 Theoretical Neuroscience - Dayan & Abbott)

% spikes: the raster
% repetitions: the beginning of each repeat
% bin_size: in the same units than SpikeTimes and EventTime
% n_bins: number of bins
% sampling_rate: acquisition rate = 1/timestep of spike times
% cells_indices: which cells to pick in SpikeTimes for the psth estimation

% PSTH: the PSTH
% XPSTH: for a proper display, use plot(XPSTH,PSTH...
% MeanPSTH: average firing rate over the defined window

time_bin = bin_size / sampling_rate;
time_bin_edges = (0 : time_bin : n_bins*time_bin);
time_bin_centers = (time_bin/2 : time_bin : time_bin/2 + (n_bins - 1) * time_bin);

n_cells = length(cells_indices);
n_reps = length(repetitions);

firing_rates = zeros(n_cells, n_reps, n_bins);
for i = 1:n_cells
    i_cell = cells_indices(i);

    spike_times = double(spikes{i_cell}).' / sampling_rate;
    rep_times = repetitions(:).' / sampling_rate;
    for j = 1:n_reps
        firing_rates(i, j, :) = histcounts(spike_times, rep_times(j) + time_bin_edges) / time_bin;
    end
end

xpsth = time_bin_centers; 
psth = squeeze(mean(firing_rates, 2));
mean_psth = squeeze(mean(psth, 2)).';