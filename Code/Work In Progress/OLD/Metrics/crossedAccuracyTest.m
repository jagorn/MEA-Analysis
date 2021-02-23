function crossedAccuracyTest(spikes_cell_array, model_predictions_mat, cells_labels, color)
% spikes_cell_array = cell_array [n_neurons * n_stimulations],
% and each cell cell_array(ni, sj) containts an array of repetitions.
% cell cell_array(ni, sj)(rk) represents the number of spikes recorded
% from neuron ni during stimlation sj and repetition rk.

% model_predictions_mat = matrix [n_neurons * n_stimulations],
% and each element matrix(ni, sj)containts the predicted number of spikes
% for neuron ni during stimlation sj.


[n_neurons, n_patterns] = size(spikes_cell_array);
if ~exist('cells_labels', 'var')
    cells_labels = 1:n_neurons;
end

neuron_consistencies = zeros(n_neurons, 1);
model_accuracies = zeros(n_neurons, 1);

firingRates_odds = zeros(n_neurons, n_patterns);
firingRates_even = zeros(n_neurons, n_patterns);

for neuron = 1:n_neurons
    
    % split repetitions in 2 groups and compute PSTHs
    for pattern = 1:n_patterns
        firingRates_odds(neuron,pattern) = mean(spikes_cell_array{neuron,pattern}(1:2:end));
        firingRates_even(neuron,pattern) = mean(spikes_cell_array{neuron,pattern}(2:2:end));
    end
    
    % check the correlation between the two PSTHs as an upper bound for
    % model accuracy
    psth_corr_mat = corrcoef(firingRates_odds(neuron, :), firingRates_even(neuron, :));
    neuron_consistencies(neuron) = max(0, psth_corr_mat(1,2));
    
    % check the correlation between model prediction and the 2 PSTHs
    % to estimate model accuracy
    model_accuracy_1_mat = corrcoef(model_predictions_mat(neuron, :), firingRates_odds(neuron, :));
    model_accuracy_2_mat = corrcoef(model_predictions_mat(neuron, :), firingRates_even(neuron, :));
    model_accuracies(neuron) = max(0, mean([model_accuracy_1_mat(1,2), model_accuracy_2_mat(1,2)]));

end

scatter(neuron_consistencies, model_accuracies, 100, color, 'Filled', 'o');
hold on
text(neuron_consistencies, model_accuracies, string(cells_labels));

plot([0, 1], [0, 1], '--', "LineWidth", 1.5, "Color", [.6, .6, .6])
pbaspect([1 1 1])
c = colorbar('Ticks', []);
c.Label.String = 'Holographic Activation';

xlabel("split PSTHs Correlation");
ylabel("Model-PSTHs Correlation");
title("Crossed Correlation Test")