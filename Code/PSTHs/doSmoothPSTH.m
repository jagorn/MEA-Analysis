function [psth, xpsth, mean_psth, firing_rates] = doSmoothPSTH(spikes, repetitions, bin_size, n_bins,  sampling_rate, cells_indices, time_res)
% Implentation of causal smooth PSTH (see page 15 Theoretical Neuroscience - Dayan & Abbott)

% spikes: the raster
% repetitions: the beginning of each repeat
% bin_size: in the same units than SpikeTimes and EventTime
% n_bins: number of bins
% sampling_rate: acquisition rate = 1/timestep of spike times
% cells_indices: which cells to pick in SpikeTimes for the psth estimation
% time_res: time resolution of the temporal Kernel (in seconds)

% PSTH: smooth PSTH with half-wave rectification Kernel
% XPSTH: for a proper display, use plot(XPSTH,PSTH...
% MeanPSTH: average firing rate over the defined window

time_bin = bin_size / sampling_rate;
time_bin_centers = (time_bin/2 : time_bin : time_bin/2 + (n_bins - 1) * time_bin);

n_cells = length(cells_indices);
n_reps = length(repetitions);

firing_rates = zeros(n_cells, n_reps, n_bins);
for i = 1:n_cells
    i_cell = cells_indices(i);
    
    spike_times = double(spikes{i_cell}).' / sampling_rate;
    rep_times = repetitions(:).' / sampling_rate;
    firing_rates(i, :, :) = getFiringRates(spike_times, time_bin_centers, rep_times, time_res);
end

xpsth = time_bin_centers; 
psth = squeeze(mean(firing_rates, 2));
mean_psth = squeeze(mean(psth, 2)).';