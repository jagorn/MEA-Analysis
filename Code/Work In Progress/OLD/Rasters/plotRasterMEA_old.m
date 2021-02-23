function plotRasterMEA_old(spike_trains, positions_MEA, duration, stim_begin, stim_end)

n_MEA = size(spike_trains, 1);
n_reps = size(spike_trains, 2);

figure();
for i_elec = 1:n_MEA    
    spike_times = [];
    spike_repeats = [];
    for i_rep = 1:n_reps
        spike_times = [spike_times spike_trains{i_elec, i_rep}];
        spike_repeats = [spike_repeats ones(1, length(spike_trains{i_elec, i_rep})) * i_rep];
    end
        
    TimesTot = spike_times/duration + double(positions_MEA(i_elec,1));
    RepeatTot = spike_repeats/n_reps + double(positions_MEA(i_elec,2));
    plot(TimesTot,RepeatTot, '.', 'color', 'b'); %,'MarkerSize',15);
    hold on
end

for i=1:16
    plot([i i],[1 17],'k')
    plot([1 17],[i i],'k')
    plot([i i] + stim_begin/duration,[1 17],'r')
    plot([i i]+ 1 - stim_end/duration,[1 17],'r')
end

set(gca,'Visible','off')
for i_elec=1:length(positions_MEA)
    text(double(positions_MEA(i_elec,1)),double(positions_MEA(i_elec,2))+0.5,int2str(i_elec))
end