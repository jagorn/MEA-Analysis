function autocorrs = doApproxPearsonAutoCorr(firing_rates)
    
    n_cells = size(firing_rates, 1);
    n_reps = size(firing_rates, 2);
    
    half_reps = floor(n_reps/2);
    
    shuffled_rep_indices = randperm(n_reps);
    rep_indices_1 = shuffled_rep_indices(1 : half_reps);
    rep_indices_2 = shuffled_rep_indices(half_reps + 1 : n_reps);
        
    firing_rates_1 = firing_rates(:, rep_indices_1, :);
    firing_rates_2 = firing_rates(:, rep_indices_2, :);
    
    psth_1 = squeeze(mean(firing_rates_1, 2));
    psth_2 = squeeze(mean(firing_rates_2, 2));
 
    autocorrs = zeros(1, n_cells);
    for i = 1:n_cells
        autocorrs(i) = corr(psth_1(i, :).', psth_2(i, :).');
    end



