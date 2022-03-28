clear
close all
clc

% Load Data
delay = 0.5; %s
load('baden_data.mat', 'chirp_stim', 'chirp_stim_time', 'group_idx', 'chirp_time', 'chirp_avg');
load('typing_results.mat', 'cellsTable', 'mosaicsTable', 'duplicate_cells', 'psths', 'names', 'colors', 'symbols', 'rfs', 'stas')
load('chirp.mat', 'euler_stim', 'euler_time');
euler_labels = readtable('Baden Types', 'Delimiter', ',');

% Adjust Time Sequences and PSTHs
fran_stim_time = euler_time + 5;
fran_stim = euler_stim -0.5;

euler_stim_time = chirp_stim_time;
euler_stim = chirp_stim / max(chirp_stim) -0.5;

dt_stepON_fran = (0.5:0.025:2) + 5 + delay;
dt_stepON_euler = 1.5:0.025:3;

dt_stepOFF_fran = (1.5:0.025:3) + 5 + delay;
dt_stepOFF_euler = 4.5:0.025:6;

time_seq_fran = cumsum(ones(1, size(psths, 2)) * 0.050) + 5 + delay;
time_seq_euler = chirp_time;
time_seq_common = 7.8:0.025:min(time_seq_fran(end), time_seq_euler(end));

psth_fran = psths;
psth_euler = chirp_avg;

% Classes to calcium
[~, mosaics_by_ID] = sort(names);
[~, mosaics_by_label] = sort(mosaics_by_ID);
calciumTable = table;

for i_entry = 3
    i_class = mosaics_by_label(i_entry);
    
    % Get class PSTHs
    class_name = mosaicsTable(i_class).class;
    class_label = symbols(names == class_name);
    class_color = colors(names == class_name);
    
    class_idx = mosaicsTable(i_class).indices & ~duplicate_cells;
    class_experiment = mosaicsTable(i_class).experiment;
    class_psth = mean(psth_fran(class_idx, :));
    class_calcium = toCalciumLinear(time_seq_fran, class_psth);
    class_calcium = class_calcium(1:numel(time_seq_fran));
    
    class_psth_offset = class_psth - min(class_psth);
    class_psth_norm = class_psth_offset / max(class_psth_offset);
    
    class_calcium_offset = class_calcium - min(class_calcium);
    class_calcium_norm = class_calcium_offset / max(class_calcium_offset);
    
    % Get common snippets to compare with baden
    class_calcium_interp = interp1(time_seq_fran, class_calcium_norm, time_seq_common);
    
    class_ON_interp = interp1(time_seq_fran, class_calcium_norm, dt_stepON_fran);
    class_ON_interp = class_ON_interp - min(class_ON_interp);
    
    class_OFF_interp = interp1(time_seq_fran, class_calcium_norm, dt_stepOFF_fran);
    class_OFF_interp = class_OFF_interp - min(class_OFF_interp);
    
    group_match = nan;
    psth_match = nan;
    corr_match = -1;
    
    group_match_2nd = nan;
    psth_match_2nd = nan;
    corr_match_2nd = -1;
    
    corrs = zeros(32, 1);
    
    % Baden types comparison
    for i_group = 1:32
        group_psth = mean(psth_euler(:, group_idx == i_group), 2);
        group_psth_offset = group_psth - min(group_psth);
        group_psth_norm = group_psth_offset / max(group_psth_offset);
        group_psth_interp = interp1(time_seq_euler, group_psth_norm, time_seq_common);
        
        group_ON_interp = interp1(time_seq_euler, group_psth_norm, dt_stepON_euler);
        group_ON_interp = group_ON_interp - min(group_ON_interp);
        
        group_OFF_interp = interp1(time_seq_euler, group_psth_norm, dt_stepOFF_euler);
        group_OFF_interp = group_OFF_interp - min(group_OFF_interp);
        
        features_fran = [class_ON_interp class_OFF_interp class_calcium_interp];
        features_euler = [group_ON_interp group_OFF_interp group_psth_interp];
        
        pearson_matrix =  corrcoef(features_fran, features_euler);
        pearson_coeff = pearson_matrix(2);
        corrs(i_group) = pearson_coeff;
        
        if pearson_coeff > corr_match
            
            group_match_2nd = group_match;
            psth_match_2nd = psth_match;
            corr_match_2nd = corr_match;
            
            group_match = i_group;
            psth_match = group_psth_norm;
            corr_match = pearson_coeff;
        end
    end
    
    
    figure();
    fullScreen();
    
    subplot(4, 1, 1);
    hold on
    ylim([-1, 1.5]);
    xlim([0, 35]);
    
    xlabel('time (s)')
    ylabel('normalized traces (a.u.)')
    
    plot(fran_stim_time, fran_stim, 'k', 'LineWidth', 1);
    
    subplot(4, 1, 2);
    hold on
    ylim([-1, 1.5]);
    xlim([0, 35]);
        
    xlabel('time (s)')
    ylabel('normalized traces (a.u.)')
    
    area(time_seq_fran, class_calcium_norm, 'FaceColor', 'cyan', 'EdgeColor', 'none', 'FaceAlpha', 0.5);
    area(time_seq_fran, class_psth_norm, 'FaceColor', 'blue', 'EdgeColor', 'none', 'FaceAlpha', 0.5);
    
    xline(time_seq_common(1), 'r--');
    xline(time_seq_common(end), 'r--');
    
    legend(["Ca^2^+ model", "M.E.A. cluster response"]);
    
    subplot(4, 1, 3);
    hold on
    ylim([-1, 1.5]);
    xlim([0, 35]);
    
    xlabel('time (s)')
    ylabel('normalized traces (a.u.)')
    
    plot(euler_stim_time, euler_stim, 'k', 'LineWidth', 1);
    
    subplot(4, 1, 4);
    hold on
    ylim([-1, 1.5]);
    xlim([0, 35]);
    
    xlabel('time (s)')
    ylabel('normalized traces (a.u.)')
    
    area(time_seq_euler, psth_match, 'FaceColor', 'cyan', 'EdgeColor', 'none', 'FaceAlpha', 0.5);

    xline(time_seq_common(1), 'r--');
    xline(time_seq_common(end), 'r--');
    
    legend(["Ca^2^+ cluster response"]);
    
    match_txt = strcat("Fran Class: ", class_label, ", Euler Class: ", euler_labels.BadenTypes{group_match}, ", pearson coef. = ", num2str(corr_match), " (2nd best coef. = ", num2str(corr_match_2nd), ")");
    suptitle(match_txt);
    waitforbuttonpress();
    close();
end