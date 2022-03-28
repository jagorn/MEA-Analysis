clear
close all
clc

load('strychnine');

n_cells = numel(cellsTable);
figure();

for i_cell = 1:n_cells
    
    subplot(2, 3, 1);
    area(t_isi, isi(i_cell, :));
    xlabel('\delta time [s]')
    ylabel('spikes count')
    title('ISI');
    
    subplot(2, 3, [2 3]);
    hold on;
    plot(t_euler_psth(2:end), psth_euler_control(i_cell, :), 'k');
    plot(t_euler_psth(2:end), psth_euler_strychnine(i_cell, :), 'r');
    legend(["control", "strychnine"]);
    ylim([0, 50]);
    xlabel('time [s]');
    ylabel('firing rate [hz]');
    title('Chirp PSTH');
    
    subplot(2, 3, 4);
    norm_spatial = (squeeze(sta_spatial(i_cell, :, :)) + 1) * 255/2;
    imagesc(norm_spatial);
    axis off
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
    plot(t_surround_psth(2:end), psth_surround_control(i_cell, :), 'k');
    plot(t_surround_psth(2:end), psth_surround_strychnine(i_cell, :), 'r');
    legend(["control", "strychnine"]);
    ylim([0, 50]);
    xlabel('time [s]');
    ylabel('firing rate [hz]');
    title('surround flash PSTH');
    
    suptitle(strcat("Cell #", num2str(i_cell), ", experiment: ", cellsTable(i_cell).experiment));
    
    waitforbuttonpress();
    %     close;
end