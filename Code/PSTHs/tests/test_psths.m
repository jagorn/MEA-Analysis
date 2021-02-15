clear
close all

% Params need all be expressed in the same time unit.
% The output firing rate is expressed as 1/(time_unit).
repetitions = [0.05 0.25 0.66 1.00];
spike_times = {[0.01, 0.03, 0.045, 0.1, 0.105, 0.14, 0.57, 0.60, 0.68, 0.67, 0.68, 1.05]';  ...
               [0.015, 0.032, 0.043, 0.1, 0.105, 0.14, 0.57, 0.60, 0.68, 0.67, 0.68, 1.05]';  ...
               [0.012, 0.031, 0.042, 0.1, 0.105, 0.14, 0.57, 0.60, 0.68, 0.67, 0.68, 1.05]'};
time_resolution = .5;

% PSTH Params
rate = 1; % Hz
n_steps = 0.3;

time_bin = 0.05; % s
bin_size = time_bin * rate;
n_bins = round(n_steps / bin_size);

n_cells = 1:numel(spike_times);
time_res = 0.01;

% Test performance & efficiency of PSTH scripts
tic
[psth_b, xpsth_b, mean_psth_b, rs_b] = doPSTH(spike_times, repetitions, bin_size, n_bins, rate, n_cells);
fprintf("binned PSTH: time = %f secs\n", toc);


tic
[psth_s, xpsth_s, mean_psth_s, rs_s] = doSmoothPSTH(spike_times, repetitions, bin_size, n_bins, rate, n_cells, time_res);
fprintf("smooth PSTH: time = %f secs\n", toc);

% Plots
figure
subplot(2,1,1)
plot(xpsth_b, psth_b)
title("Binned PSTH")
subplot(2,1,2)
plot(xpsth_s, psth_s)
title("Smooth PSTH")
