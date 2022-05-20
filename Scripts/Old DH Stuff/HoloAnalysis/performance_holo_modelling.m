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

% Truths vs Predicted Responses
t = truths(cells_to_model_Is, :);
t = t(:)';
p = predictions(cells_to_model_Is, :);
p = p(:)';

my_accuracies = accuracy(cells_to_model_Is);
my_accuracies(my_accuracies < 0) = 0;
my_accuracies(isnan(my_accuracies)) = 0;

my_mse = mse(cells_to_model_Is);
my_mse(isnan(my_mse)) = 0;

% Accuracies & MSE
accuracy_bins = 0:0.02:1;
accuracy_binned = zeros(size(accuracy_bins));
for a = my_accuracies
   for i_bin = 1:numel(accuracy_bins)
       bin = accuracy_bins(i_bin);
       if a >= bin
           accuracy_binned(i_bin) = accuracy_binned(i_bin) + 1;
       end
   end
end

mse_bins = 0:0.02:15;
mse_binned = zeros(size(mse_bins));
for m = my_mse
   for i_bin = 1:numel(mse_bins)
       bin = mse_bins(i_bin);
       if m <= bin
           mse_binned(i_bin) = mse_binned(i_bin) + 1;
       end
   end
end

figure();
subplot(1, 3, 1);
area(accuracy_bins, accuracy_binned, 'FaceColor', 'b', 'FaceAlpha', 0.5, 'EdgeAlpha', 0);
set(gca, 'XDir','reverse');
xline(0.6, 'k--', 'LineWidth', 1); 
ylim([0, 20]);
ylabel('number of cells');
xlabel('model accuracy (a.u.)');
title('Accuracy cumulative-count histogram');

subplot(1, 3, 2);
area(mse_bins, mse_binned, 'FaceColor', 'r', 'FaceAlpha', 0.5, 'EdgeAlpha', 0);
ylim([0, 20]);
ylabel('number of cells');
xlabel('model mean-squared-error (hz^2)');
title('Mean-Squared Error cumulative-count histogram');

subplot(1, 3, 3);
hold on
scatter(t, p, 'b', 'Filled', 'MarkerFaceAlpha', 0.5, 'MarkerEdgeAlpha', 0);
plot([0, 15], [0, 15], 'k--', 'LineWidth', 2)
daspect([1 1 1])
xlabel('True Firing Rate (Hz)')
ylabel('Predicted Firing Rate (Hz)')
xlim([0, 15]);
ylim([0 15]);
title('Predicted vs True Response Firing Rates');

