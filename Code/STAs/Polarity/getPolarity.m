function polarities = getPolarity(temporalSTAs, baseline_bins)

if ~exist('baseline_bins', 'var')
    baseline_bins = 1:5;
end

baseline = mean(temporalSTAs(:, baseline_bins), 2);

n_cells = size(temporalSTAs, 1);
for i_cell = 1:n_cells
    norm_sta = temporalSTAs(i_cell, :) - baseline(i_cell);
    if   abs(max(norm_sta)) > abs(min(norm_sta))
        polarities(i_cell) = "ON";
    else
        polarities(i_cell) = "OFF";
    end
end

