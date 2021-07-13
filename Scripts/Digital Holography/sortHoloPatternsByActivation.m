function [norm_scores, pattern_order] = sortHoloPatternsByActivation(exp_id, dh_session_id, i_cell)
    
psths = getHolographyPSTHs(exp_id);
multi_psth = psths(dh_session_id);

norm_scores = multi_psth.activations.scores(:, i_cell);
norm_scores(norm_scores < 0) = 0;
[~, pattern_order] = sort(norm_scores, 'descend');