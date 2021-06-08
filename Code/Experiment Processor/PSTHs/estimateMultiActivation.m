function [zs, thresholds, scores] = estimateMultiActivation(multi_psth, ctrl_win, resp_win, k, min_fr)


n_patterns = size(multi_psth.responses, 1);
n_cells = size(multi_psth.responses, 2);

zs = zeros(n_patterns, n_cells);
thresholds = zeros(n_patterns, n_cells);
scores = zeros(n_patterns, n_cells);

xpsth = multi_psth.time_sequences;
dt_psth = multi_psth.t_bin;

for i_pattern = 1:n_patterns
    
    psth = squeeze(multi_psth.responses(i_pattern, :, :));
    [z, threshold, score] = estimateZscore(psth, xpsth, dt_psth, ctrl_win, resp_win, k, min_fr);
    zs(i_pattern, :) = z;
    thresholds(i_pattern, :) = threshold;
    scores(i_pattern, :) = score;   
end