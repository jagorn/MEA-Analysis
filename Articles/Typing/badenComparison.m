clear
close all
% clc

global density_retina, density_retina = 5/1000; % microns⁻²
delay = 0.5;
plot_stim = false;
plot_correlations = false;
plot_matches = false;
plot_coverage = false;

mea_area = 510 * 510;  % microns

% Homographies

H_check2dmd = getHomography('CHECKER20', 'DMD');
H_dmd2camera = getHomography('DMD', 'CAMERA');
H_camera10x2MEA = getHomography('CAMERA_X10', 'MEA');
H_check2MEA = H_camera10x2MEA * H_dmd2camera * H_check2dmd;
MEA_surface = polyshape([0, 0, 510, 510], [510, 0, 0, 510]);

% Load Data

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

% Plot Stimuli

if plot_stim
    figure();
    xlim([0, 30]);
    ylim([-1, 1.5]);
    hold on
    plot(euler_stim_time, euler_stim, 'r', 'LineWidth', 1);
    plot(fran_stim_time, fran_stim, 'b--', 'LineWidth', 1);
    legend(["Euler Chirp", "Fran Chirp"]);
    xlabel('time [s]');
    ylabel('normalized intensity');
end

% Classes to calcium
[~, mosaics_by_ID] = sort(names);
[~, mosaics_by_label] = sort(mosaics_by_ID);
calciumTable = table;

for i_entry = 1:numel(mosaics_by_label)
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
        
        % Plot Features Correlation
        if plot_correlations
            figure()
            subplot(1, 3, 1);
            plot(class_ON_interp);
            hold on;
            plot(group_ON_interp);
            
            subplot(1, 3, 2);
            plot(class_OFF_interp);
            hold on;
            plot(group_OFF_interp);
            
            subplot(1, 3, 3);
            plot(class_calcium_interp);
            hold on;
            plot(group_psth_interp);
            
            waitforbuttonpress();
            close();
        end
    end
    
    
    if plot_matches
        figure();
        fullScreen();
        
        subplot(2, 1, 1);
        title("Fran's class");
        hold on
        ylim([-1, 1.5]);
        xlim([0, 35]);
        
        xlabel('time (s)')
        ylabel('normalized traces (a.u.)')
        
        plot(fran_stim_time, fran_stim, 'k', 'LineWidth', 1);
        area(time_seq_fran, class_calcium_norm, 'FaceColor', 'cyan', 'EdgeColor', 'none', 'FaceAlpha', 0.5);
        area(time_seq_fran, class_psth_norm, 'FaceColor', 'blue', 'EdgeColor', 'none', 'FaceAlpha', 0.5);
        
        xline(time_seq_common(1), 'r--');
        xline(time_seq_common(end), 'r--');
        
        legend(["chirp", "Ca^2^+ model", "MEA PSTH"]);
        
        subplot(2, 1, 2);
        title("Euler's class");
        hold on
        ylim([-1, 1.5]);
        xlim([0, 35]);
        
        xlabel('time (s)')
        ylabel('normalized traces (a.u.)')
        
        plot(euler_stim_time, euler_stim, 'k', 'LineWidth', 1);
        area(time_seq_euler, psth_match, 'FaceColor', 'cyan', 'EdgeColor', 'none', 'FaceAlpha', 0.5);
        
        xline(time_seq_common(1), 'r--');
        xline(time_seq_common(end), 'r--');
        
        legend(["chirp", "Ca^2^+ PSTH"]);
        
        match_txt = strcat("Fran Class: ", class_label, ", Euler Class: ", euler_labels.BadenTypes{group_match}, ", pearson coef. = ", num2str(corr_match), " (2nd best coef. = ", num2str(corr_match_2nd), ")");
        suptitle(match_txt);
        saveas(gcf, strcat('plots/calciumMatch_', class_label, '.png'));
        close();
    end
    
    % Compute Coverage
    class_rfs = rfs(class_idx);
    surface_coverage = polyshape([0, 0, 0, 0], [0, 0, 0, 0]);
    
    % Transform rfs into MEA reference frame
    for i_rf = 1:numel(class_rfs)
        class_rfs(i_rf).Vertices = transformPointsV(H_check2MEA, class_rfs(i_rf).Vertices);
        surface_coverage = union(surface_coverage, class_rfs(i_rf));
    end
    surface_coverage = intersect(surface_coverage, MEA_surface);
    class_coverage = area(surface_coverage) / area(MEA_surface);
        
    % Compute Bias
    n_cells_experiment = sum([cellsTable.experiment] == class_experiment);
    class_bias = computeBiasType(class_rfs, n_cells_experiment, mea_area);
    
    if plot_coverage
        figure();
        daspect([1 1 1]);
        hold on
        plot(surface_coverage, 'FaceColor', 'b', 'EdgeColor', 'none', 'FaceAlpha', 0.3);
        for class_rf = class_rfs
            plot(class_rf, 'FaceColor', 'none', 'EdgeColor', 'k');
        end
        plot(MEA_surface, 'FaceColor', 'none', 'EdgeColor', 'k');
        plotElectrodesMEA();
        title(strcat(class_label, ": Class Coverage = ", num2str(round(class_coverage*100)), "%, Bias = ", num2str(class_bias)));
        xlim([-200 800]);
        ylim([-200 800]);
        saveas(gcf, strcat('plots/calciumCoverage_', class_label, '.png'));
        close();
    end
   
    calciumTable.ID(i_entry) = class_name;
    calciumTable.classMEA(i_entry) = class_label;
    calciumTable.experimentMEA(i_entry) = class_experiment;
    calciumTable.coverageMEA(i_entry) = class_coverage;
    calciumTable.nnd(i_entry) = computeMedianNND(class_rfs);
    calciumTable.size(i_entry) = numel(class_rfs);
    calciumTable.samplingBias(i_entry) = class_bias;
    calciumTable.classCalcium(i_entry) = string(euler_labels.BadenTypes{group_match});
    calciumTable.corrCoef(i_entry) = corr_match;
    calciumTable.classCalcium2nd(i_entry) = string(euler_labels.BadenTypes{group_match_2nd});
    calciumTable.corrCoef2nd(i_entry) = corr_match_2nd;
end
disp(calciumTable)
save('calcium_comparison.mat', 'calciumTable')



%% Functions

function expected_size = expectedClusterSize(nnd, mea_area)
exagon_area = nnd^2 * sqrt(3) / 2;
expected_size = mea_area / exagon_area;
end

function prob_type = samplingProbType(size_type, nnd_type, mea_area)
expected_size = expectedClusterSize(nnd_type, mea_area);
prob_type = size_type / expected_size;
end

function prob_recording = samplingProbExperiment(n_cells_recorded, mea_area)
global density_retina;
prob_recording = n_cells_recorded / (density_retina * mea_area);
end

function nnd_type = computeMedianNND(rfs)
[cXs, cYs] = arrayfun(@centroid, rfs);
distances_mat = squareform(pdist([cXs', cYs'])) + diag(ones(numel(rfs), 1)*inf);
nnds = min(distances_mat);
nnd_type = median(nnds);
end

function bias = computeBiasType(rfs_type, n_cells_experiment, mea_area)
n_cells_type = numel(rfs_type);
nnd_type = computeMedianNND(rfs_type);
prob_type = samplingProbType(n_cells_type, nnd_type, mea_area);
prob_recording = samplingProbExperiment(n_cells_experiment, mea_area);
bias = log(prob_type) - log(prob_recording);
end
