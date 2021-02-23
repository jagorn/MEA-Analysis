function activation = computeActivation(spike_counts)

% spike_counts = {1* n_patterns}, each cell = [1 * n_repetitions]

pattern_rates = cellfun(@mean, spike_counts);
pattern_vars = cellfun(@var, spike_counts);
activation_num = var(pattern_rates);
activation_den = mean(pattern_vars);

activation = activation_num/activation_den;
activation(isnan(activation)) = 0;
