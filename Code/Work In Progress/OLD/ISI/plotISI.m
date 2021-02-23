function plotISI(spike_times, mea_rate)

ISI = diff(spike_times / mea_rate);
ISI = ISI(ISI<=25);
histogram(ISI, 100);


