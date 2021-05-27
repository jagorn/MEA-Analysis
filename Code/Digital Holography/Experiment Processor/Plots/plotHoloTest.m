function plotHoloTest(exp_id,section_id)

repetitions = getHolographyRepetitions(exp_id, section_id);
spike_times = getSpikeTimes(exp_id);
tags = getTags(exp_id);
rate = getMeaRate(exp_id);

[~, best_cells] = sort(tags);

for i_cell = best_cells(:)'
    figure();
    fullScreen();
    plotStimRaster(spike_times{i_cell}, repetitions.rep_begin, median(repetitions.durations), rate)
    title(strcat("DH activations cell#", num2str(i_cell)));
    waitforbuttonpress();
    close;
end