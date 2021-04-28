clear
load(getDatasetMat(), "dh", "dh_stats", "dh_models")

% indices = and(dh_stats.test.activation > 0.3, dh_stats.singles.activation > 0.3);
indices = dh_stats.test.activation > .5;
neurons_spikes = dh.responses.test.spikeCounts(indices, :);
models_predictions = dh_models.LNP.predictions(indices, :);
firing_rates = dh_models.LNP.firingRates(indices, :);
cells_indices = find(indices);

activation = dh_stats.test.activation(indices);
accuracy = dh_models.LNP.accuracies(indices);

accuracy = max(0, accuracy);
crossedAccuracyTest(neurons_spikes, models_predictions, cells_indices, activation);


figure()
histogram(accuracy, 15, 'EdgeColor', 'blue')
yticks([1:5]);
ylim([0,5]);