function norm_tsta = normalizeTemporalSTA(tsta, baseline_size)

if ~exist('baseline_size', 'var')
    baseline_size = 6;
end

norm_tsta_baseline = tsta(:, 1:baseline_size);
norm_tsta = tsta(:, baseline_size+1 : size(tsta, 2));
norm_tsta = norm_tsta - mean(norm_tsta_baseline, 2);
norm_tsta = norm_tsta ./ std(norm_tsta, [], 2);