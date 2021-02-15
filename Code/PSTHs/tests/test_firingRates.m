clear
close all
% Params need all be expressed in the same time unit.
% The output firing rate is expressed as 1/(time_unit).
time_window = 0:0.01:1;
repetitions = [0.05 0.25 0.66 1.00];
spike_times = [0.01, 0.03, 0.045, 0.1, 0.105, 0.14, 0.57, 0.60, 0.68, 0.67, 0.68, 1.05];
time_resolution = .5;

times_init = repetitions - time_resolution * 10;
times_end = repetitions + time_window(end);

spike_trains = extractSpikeTrains(spike_times, times_init, times_end, repetitions);
firing_rates = getFiringRates(spike_times, time_window, repetitions, time_resolution);

figure()
max_y = max(firing_rates(:));
for i = 1:length(repetitions)
    repetition_window = repetitions(i) + time_window;
    plot(repetition_window, firing_rates(i,:), "LineWidth", 3);
    
    title(strcat("firing rates - repetition # ", string(i)));
    xlabel("time (s)")
    ylabel("firing rate (Hz)")
    ylim([0, max_y]);
    
    g = sprintf('%f ',  spike_trains{i});
    fprintf("spike train of rep #%i: %s\n", i, g);
    
    waitforbuttonpress;
    
end