function plotHoloTest(exp_id,section_id)

plot_columns = 6;
repetitions = getHolographyRepetitions(exp_id, section_id);
spike_times = getSpikeTimes(exp_id);
tags = getTags(exp_id);
rate = getMeaRate(exp_id);

[~, best_cells] = sort(tags);

i_column = 1;
for i_cell = best_cells(:)'
    
    if i_column == 1
        figure();
        fullScreen();
    end
    
    subplot(1, plot_columns, i_column);
    plotStimRaster(spike_times{i_cell}, repetitions.rep_begins, median(repetitions.durations), rate)
    title(strcat("DH activations cell#", num2str(i_cell)));
    waitforbuttonpress();

    i_column = i_column + 1;
    if i_column > plot_columns
        close;
        i_column = 1;
    end
end