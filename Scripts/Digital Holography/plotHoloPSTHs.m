function plotHoloPSTHs(exp_id, n_dh_session, n_spots, set_types)
plot_columns = 6;
n_patterns_show = 25;

rate = getMeaRate(exp_id);
spikes = getSpikeTimes(exp_id);
tags = getTags(exp_id);
repetitions = getHolographyRepetitions(exp_id, n_dh_session);
psths = getHolographyPSTHs(exp_id);
multi_psth = psths(n_dh_session);

patterns = filterHoloPatterns(repetitions, "Set_Types", set_types, "Allowed_N_Spots", n_spots);

[~, good_patterns_idx] = sort(sum(multi_psth.zs(patterns, :), 2), 'descend');
good_patterns = patterns(good_patterns_idx(1:n_patterns_show));


[cells_activations, good_cells] = sort(sum(multi_psth.zs(good_patterns, :)), 'descend');
good_cells = good_cells(cells_activations>=0);

good_rep_begins = repetitions.rep_begins(good_patterns);
good_durations = median(repetitions.durations(good_patterns));

% recap plots
z_plot = multi_psth.zs(patterns, good_cells);

figure();
subplot(2, 2, 3);
imagesc(z_plot);
xlabel('cells')
ylabel('patterns');

subplot(2, 2, 1);
bar(sum(z_plot), 'g')
title('number of activations by cells');
xlim([0.5, numel(sum(z_plot))+0.5])
axis off

subplot(2, 2, 4);
barh(sum(z_plot, 2), 'r')
title('number of activated cells by pattern');
ylim([0.5, numel(sum(z_plot, 2))+0.5])
axis off


i_column = 1;
for i_cell = good_cells(:)'
    
    if i_column == 1
        figure();
        fullScreen();
    end
    
    activations = find(multi_psth.zs(good_patterns, i_cell))';
    
    subplot(1, plot_columns, i_column);
    plotStimRaster(spikes{i_cell}, good_rep_begins, good_durations, rate)
    title([strcat("cell#", num2str(i_cell), " (tag=", num2str(tags(i_cell)), ")"); strcat("actPatt = ", num2str(activations))]);
    waitforbuttonpress();

    i_column = i_column + 1;
    if i_column > plot_columns
        close;
        i_column = 1;
    end
end
