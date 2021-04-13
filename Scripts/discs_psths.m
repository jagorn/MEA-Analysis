clear
close all

load('/home/fran_tr/Projects/MEA_Analysis/Scripts/20201117_gtacrMatrix.mat', 'spikes', 'black', 'white', 'only')
load('/home/fran_tr/Data/20201117_gtacr/processed/Discs/discs.mat');
pattern_reps = {reps_white_disc, reps_black_disc};

meaRate = 20000;
bin_size = 0.05 * meaRate;
n_bins = 10;
window = 6:10;
window_dh = 1:5;

[psths_white_disc, time] = doPSTH(spikes, reps_white_disc, bin_size, n_bins, meaRate, 1:numel(spikes));
psths_black_disc = doPSTH(spikes, reps_black_disc, bin_size, n_bins, meaRate, 1:numel(spikes));

save('/home/fran_tr/Projects/MEA_Analysis/Scripts/20201117_gtacrMatrix.mat', 'psths_white_disc', 'psths_black_disc', '-append')

psths_white_discDH = white.responses.single.firingRates;
psths_black_discDH = black.responses.single.firingRates;
psths_only_DH = only.responses.single.firingRates;

% for i_cell = 1:60
i_cell = 3;
    for i_spot = 1:24
        %         black_inhibition(i_cell, i_spot) = max(psths_black_disc(i_cell, window)) -  max(psths_black_discDH(i_cell, i_spot, window));
        %         white_inhibition(i_cell, i_spot) = max(psths_white_disc(i_cell, window)) -  max(psths_white_discDH(i_cell, i_spot, window));
        %
        black_inhibition(i_cell, i_spot) = mean(psths_black_disc(i_cell, window)) -  mean(psths_black_discDH(i_cell, i_spot, window));
        white_inhibition(i_cell, i_spot) = mean(psths_white_disc(i_cell, window)) -  mean(psths_white_discDH(i_cell, i_spot, window));
        dh_effect(i_cell, i_spot) = mean(psths_white_discDH(i_cell, i_spot, window_dh));
    end
    
    figure();
    hold on;
    plot(time, psths_white_disc(i_cell, :), 'LineWidth', 2);
    plot(time, squeeze(psths_white_discDH(i_cell, i_spot, :)), 'LineWidth', 2);
    xlabel('Time (s)')
    ylabel('Firing Rate (Hz)')
    legend({'Disc', 'Disc & Holography'})
    title('ON Cell Resonse to Disc (Center)')
        waitforbuttonpress();
    close()
% end

save('/home/fran_tr/Projects/MEA_Analysis/Scripts/20201117_gtacrMatrix.mat', 'black_inhibition', 'white_inhibition', 'dh_effect', '-append');