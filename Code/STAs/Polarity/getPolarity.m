function polarities = getPolarity(temporalSTAs, baseline_bins)

ratio = 1.2;

if ~exist('baseline_bins', 'var')
    baseline_bins = 1:5;
end

baseline = mean(temporalSTAs(:, baseline_bins), 2);
sigma = std(temporalSTAs(:, baseline_bins), [], 2);

n_cells = size(temporalSTAs, 1);
for i_cell = 1:n_cells
    norm_sta = temporalSTAs(i_cell, :) - baseline(i_cell);
    
    if  ( abs(max(norm_sta)) > (abs(min(norm_sta)) * ratio) ) &&  ( abs(max(norm_sta)) > (baseline(i_cell) + 5*sigma(i_cell)) )
        polarities(i_cell) = "ON";
    elseif ( abs(min(norm_sta)) > (abs(max(norm_sta)) * ratio) ) &&  ( abs(min(norm_sta)) > (baseline(i_cell) + 5*sigma(i_cell)) )
        polarities(i_cell) = "OFF";
    elseif ( abs(max(norm_sta)) > (baseline(i_cell) + 5*sigma(i_cell)) ) &&  ( abs(min(norm_sta)) > (baseline(i_cell) + 5*sigma(i_cell)) )
        polarities(i_cell) = "ON-OFF";
    else
        polarities(i_cell) = "NONE";
    end
end

