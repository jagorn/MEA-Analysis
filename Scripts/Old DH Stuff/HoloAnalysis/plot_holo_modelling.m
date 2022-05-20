clear;
close all;

% Constants
exp_id = '20170614_rbc';
dh_section_id = 1;
min_number_reps = 5;

% Load Models
load('/home/fran_tr/Data/20170614_rbc/processed/Modelling/20170614Matrix.mat', 'cellsTable', 'temporalSTAs', 'spatialSTAs', 'stas');
load('/home/fran_tr/Data/20170614_rbc/processed/Modelling/LNP.mat')
cell_Ns = [cellsTable.N];
cell_Is = 1:numel(cellsTable);

% Load Holography
[holo_section , i_section] = getHoloSection(exp_id, dh_section_id);
holo_psths = getHolographyPSTHs(exp_id);
holo_psth = holo_psths(i_section);
holo_positions = holo_psth.psth.pattern_positions.mea;
n_spots = size(holo_positions, 1);
spots = 1:n_spots;

% Load Homographies
HDMD_2_Camera = getHomography('DMD', 'CAMERA');
HCamera_2_MEA = getHomography('CAMERA_X10', 'MEA');
HChecker_2_DMD = getHomography('CHECKER20', 'DMD');

% Compose Homographies
HChecker_2_MEA = HCamera_2_MEA * HDMD_2_Camera * HChecker_2_DMD;

% Select Patterns
patterns_1s = filterHoloPatterns(getHolographyRepetitions(exp_id, dh_section_id), ...
    "Allowed_N_Spots", 1, ...
    "N_Min_Repetitions", min_number_reps);
patterns_2s = filterHoloPatterns(getHolographyRepetitions(exp_id, dh_section_id), ...
    "Allowed_N_Spots", 2, ...
    "N_Min_Repetitions", min_number_reps);
patterns = [patterns_1s; patterns_2s];

% Load Activations and Filter Cells
[activations, ~] = getHoloActivations(exp_id, dh_section_id);
activated_patterns2goodcells = activations.zs(patterns_2s, cell_Ns) ~= 0;
activated_goodcells = find(any(activated_patterns2goodcells));
cells_to_model_Ns = cell_Ns(activated_goodcells);
cells_to_model_Is = cell_Is(activated_goodcells);

% Sort by performance
[sorted_accuracies, sorted_idx] = sort(accuracy, 'descend');

% Normalize Weights
max_weights = max(abs(ws), [], 2);
norm_ws =   ws ./ max_weights;
norm_b = b(:)' .* max_weights(:)';


% Plot Accuracies

histogram(accuracy(cells_to_model_Is), 0:0.02:1, 'Normalization', 'cumcount');


% Plot Weights
for i_cell = sorted_idx(:)'
    
    cell_N = cell_Ns(i_cell);
    cell_I = cell_Is(i_cell);
    
    cell_weights = norm_ws(cell_I, :);
    cell_b = norm_b(cell_I);
    cell_c = c(cell_I);
    cell_accuracy = accuracy(cell_I);
    
    tsta = temporalSTAs(cell_I, :);

    if isnan(cell_accuracy)
        continue
    end
    
    % Figure
    pause(2);
    figure();
    fullScreen();
    
    subplot(3, 4, [1 2 3 5 6 7 9 10 11]);
    
    % plot STA
    sta = stas{cell_I};
    spatial_sta = squeeze(std(sta, [], 3));
    temporal_sta = temporalSTAs(cell_I, :);
    rf = spatialSTAs(cell_I);

    [sta_2mea, staRef_2mea] = transformImage(HChecker_2_MEA, spatial_sta);
    sta_2mea = max(sta_2mea(:)) - sta_2mea;
    sta_2mea = sta_2mea /max(sta_2mea(:));

    t = imshow(sta_2mea, staRef_2mea);
    set(t, 'AlphaData', 0.8);
    hold on

    % plot Receptive Field
    rf.Vertices = transformPointsV(HChecker_2_MEA, rf.Vertices);    
    [x, y] = boundary(rf);
    plot(x, y, 'k', 'LineWidth', 3);

    % labels and colorbars
    xlabel('Microns');
    ylabel('Microns');

    % plot MEA
    plotElectrodesMEA();
    xlim([255-300, 255+300])
    ylim([255-300, 255+300])

    % plot Spots
    [colors, colorbar] = value2HeatColor(cell_weights, -1, +1, true);
    for i_spot = 1:n_spots
        spot = spots(i_spot);
        color_spot = colors(i_spot, :);
        position_spot = holo_positions(spot, :);
        scatter(position_spot(1), position_spot(2), 100, color_spot, "Filled", 'MarkerEdgeColor', [0.1 0.1 0.1]);
    end
    title('Linear Weights');

    subplot(3, 4, 4);
    text_title  = strcat("Cell #", num2str(cell_I), " Accuracy: ", num2str(cell_accuracy));
    axis off
    title(text_title);
    
    subplot(3, 4, 8);
    dt = 1/30;
    temporal_x = dt*numel(temporal_sta)-dt:-dt:0;
    
    xlabel('time (s))');
    ylabel('normalized sta (a.u.)');
    plot(temporal_x, temporal_sta, 'k', 'LineWidth', 2);
    xlabel('time (s)');
    ylabel('normalized sta (a.u.)');
    title('Temporal STA');

    subplot(3, 4, 12);
    x = linspace(0, 0.2, 100);
    y = exp(x * cell_b + cell_c);
    plot(x, y, 'k', 'LineWidth', 2);
    ylim([0 100]);
    xlim([0 0.2]);
    xlabel('generator signal (a.u.)');
    ylabel('predicted firing rate (hz)');
    title('Non-Linearity');

%     pause(2);
%     plotColorBar(colorbar, -1, +1, 'Linear Weights)')

    waitforbuttonpress();
    close all;
end