function S = spikeTrainsSynchrony(firing_rates)

[n_cells, n_reps, ~] = size(firing_rates);
S = zeros(1, n_cells);

for i_cell = 1:n_cells
    
    sum_s = 0;
    for i_rep = 1:(n_reps - 1)
        for j_rep = (i_rep + 1):n_reps
            
            rep_i = firing_rates(i_cell, i_rep, :);
            rep_j = firing_rates(i_cell, j_rep, :);
            s = corr(rep_i(:), rep_j(:));
            s(isnan(s)) = 0;
            s(s < 0) = 0;

            sum_s = sum_s + s;
        end
    end
    S(i_cell) = 2 * sum_s / (n_reps * (n_reps - 1));
end