clear
close all
clc

% Load
load('strychnine');
load('Data/euler_stim.mat', 'chirp_stim', 'chirp_stim_time');
chirp_stim = chirp_stim - min(chirp_stim(:));
chirp_stim = chirp_stim / max(chirp_stim(:)) * 30 + 10;

% Choose cells
off_cells = [cellsTable.polarity] == "OFF";
on_cells = [cellsTable.polarity] == "ON";
surround_cells = distance_surround > 0;
surround_activated = activations.control.z > 0;
strychnine_activated = activations.strychnine.z > 0;

cell_idx = find(off_cells & surround_cells & (surround_activated | strychnine_activated));
% cell_idx = find(strychnine_activated);

% Recap Plot
% figure();
% 
% subplot(1, 3, 3);
% hold on
% plot([-25, 50], [-25, 50], '--', 'Color', [0, 0, 0, 0.5]);
% scatter(activations.control.z(cell_idx), activations.strychnine.z(cell_idx), 30, 'b', 'Filled', 'MarkerFaceAlpha', 0.5, 'MarkerEdgeAlpha', 0);
% xlabel('surr. resp. control [\delta fr]');
% ylabel('surr. resp. strychnine [\delta fr]');
% daspect([1, 1, 1]);
% ylim([-25, 50]);
% xlim([-25, 50]);
% 
% all_data = [activations.control.z(cell_idx) activations.strychnine.z(cell_idx)];
% edge_min = min(all_data);
% edge_max = max(all_data);
% edges = linspace(edge_min, edge_max, 20);
% 
% subplot(1, 3, 1);
% histogram(activations.control.z(cell_idx), edges, 'Normalization','probability');
% ylim([0, 1]);
% ylabel('probability');
% xlabel('surround response [\delta fr]');
% title('Control');
% 
% subplot(1, 3, 2);
% histogram(activations.strychnine.z(cell_idx), edges, 'Normalization','probability');
% ylim([0, 1]);
% ylabel('probability');
% xlabel('surround response [\delta fr]');
% title('Strychnine');
% 
% suptitle(strcat("Surround-Activated OFF RGCs (size ", num2str(numel(cell_idx)), ")"));
% waitforbuttonpress();

% Figures
figure();
fullScreen();

for i_cell = cell_idx
    
    if isequal(cellsTable(i_cell).polarity, 'NONE')
        continue;
    end
    
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
    plot(rfs(i_cell));
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
    
    yline(activations.control.t_up(i_cell), 'k--');
    yline(activations.strychnine.t_up(i_cell), 'r--');
    
    legend([p0, p1, p2], ["stimulus", "psth control", "psth strychnine"]);
    ylim([0, 50]);
    xlabel('time [s]');
    ylabel('firing rate [hz]');
    title('surround flash PSTH');
    
    suptitle(strcat("Cell #", num2str(cellsTable(i_cell).N), ", experiment: ", cellsTable(i_cell).experiment, ", polarity ", cellsTable(i_cell).polarity, ", grade = ", cellsTable(i_cell).grade));
    
    export_fig(strcat('Plots/cards/StrychnineCard_Cell#', num2str(cellsTable(i_cell).N), '.png'));
end