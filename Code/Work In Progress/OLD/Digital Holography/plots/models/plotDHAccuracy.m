
session = 'DHMulti';
model = 'LNP';
activation_thresh = 0.5; % from -1 to 1
n_reps_min = 0;

s = load(getDatasetMat(), session);

indices =  s.(session).activation > activation_thresh;
cells_indices = find(indices);

spike_counts = s.(session).responses.test.spikeCounts(indices, :);
models_predictions = s.(session).(model).predictions(indices, :);
activation = s.(session).activation(indices);

valid_patterns = cellfun(@numel, spike_counts(1,:)) >= n_reps_min;
spike_counts = spike_counts(:, valid_patterns);
models_predictions = models_predictions(:, valid_patterns);

[n_cells, n_patterns] = size(spike_counts);
firingRates = zeros(n_cells, n_patterns);
accuracies_valid_patterns = zeros(n_cells, 1);
for i_cell = 1:n_cells
    for pattern = 1:n_patterns
        firingRates(i_cell,pattern) = mean(spike_counts{i_cell,pattern});
    end
    corr_mat = corrcoef(models_predictions(i_cell, :), firingRates(i_cell, :));
    accuracies_valid_patterns(i_cell) = corr_mat(1,2);
end

figure()
fullScreen()

subplot(1, 2, 1);
crossedAccuracyTest(spike_counts, models_predictions, cells_indices, activation);

subplot(1, 2, 2);
histogram(accuracies_valid_patterns, 15, 'EdgeColor', 'blue')
ylabel("number of cells")
xlabel("model accuracy")