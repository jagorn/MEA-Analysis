clear
% close all
clc

load('strychnine');
load('Data/euler_stim.mat', 'chirp_stim', 'chirp_stim_time');
chirp_stim = chirp_stim - min(chirp_stim(:));
chirp_stim = chirp_stim / max(chirp_stim(:)) * 30 + 10;

n_cells = numel(cellsTable);
figure();
fullScreen();

for i_cell = 1:n_cells
    
    subplot(2, 3, 1);
    area(t_isi, isi(i_cell, :));
    xlabel('\delta time [s]')
    ylabel('spikes count')
    title('ISI');
    
    subplot(2, 3, [2 3]);
    hold on;
    plot(chirp_stim_time, chirp_stim, 'LineWidth', 1, 'Color', [0.5, 0.5, 0.5, 0.5]);
    plot(t_euler_psth(2:end), psth_euler_control(i_cell, :), 'k');
    plot(t_euler_psth(2:end), psth_euler_strychnine(i_cell, :), 'r');
    legend(["stimulus", "psth control", "psth strychnine"]);
    ylim([0, 50]);
    xlim([0, 30])
    xlabel('time [s]');
    ylabel('firing rate [hz]');
    title('Chirp PSTH');
    
    subplot(2, 3, 4);
    norm_spatial = (squeeze(sta_spatial(i_cell, :, :)) + 1) * 255/2;
    imagesc(norm_spatial);
    axis off
    hold on;
    rectangle('Position', [0.5, 18.5, 24, 6], 'FaceColor', [1, 1, 1, 0.6], 'EdgeColor', 'white');
    daspect([1, 1, 1]);
    title('spatial STA');
    
    subplot(2, 3, 5);
    hold on
    yline(0, 'k--');
    plot(sta_temporal(i_cell, 21:end), 'r', 'LineWidth', 1);
    ylim([-0.5, +0.5]);
    axis off
    title('temporal STA');
    
    subplot(2, 3, 6);
    hold on;
    p0 = area([1.5 2.5], [100 100], 'FaceColor', 'yellow', 'FaceAlpha', 0.3, 'EdgeColor', 'None');
    p1 = plot(t_surround_psth, psth_surround_control(i_cell, :), 'k');
    p2 = plot(t_surround_psth, psth_surround_strychnine(i_cell, :), 'r');
    legend([p0, p1, p2], ["stimulus", "psth control", "psth strychnine"]);
    ylim([0, 50]);
    xlabel('time [s]');
    ylabel('firing rate [hz]');
    title('surround flash PSTH');
    
    suptitle(strcat("Cell #", num2str(cellsTable(i_cell).N), ", experiment: ", cellsTable(i_cell).experiment, ", polarity ", cellsTable(i_cell).polarity, ", grade = ", cellsTable(i_cell).grade));
    
    waitforbuttonpress();
    %     close;
end