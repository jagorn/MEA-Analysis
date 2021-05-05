function plotInterSpikeInterval(spike_times, mea_rate)

ISI = diff(spike_times / mea_rate) * 1000;  % Convert to ms
ISI = ISI(ISI <= 250);
histogram(ISI, 100, 'Normalization', 'probability');
xlabel('inter-spike intervals (ms)')
ylabel('interval probability')

