function [polarities, on_cells, off_cells, none_cells] = getPolarity(temporalSTAs, ratio_threshold, baseline_bins)


if ~exist('ratio_threshold', 'var')
    ratio_threshold = 2;
end

if ~exist('baseline_bins', 'var')
    baseline_bins = 1:5;
end

baseline = mean(temporalSTAs(:, baseline_bins), 2);

n_cells = size(temporalSTAs, 1);
for i_cell = 1:n_cells
    norm_sta = temporalSTAs(i_cell, :) - baseline(i_cell);
    if abs(max(norm_sta)) / abs(min(norm_sta)) > ratio_threshold
        polarities(i_cell) = "ON";
    elseif  abs(min(norm_sta)) / abs(max(norm_sta)) > ratio_threshold
        polarities(i_cell) = "OFF";
    else
        polarities(i_cell) = "NONE";
    end
end

on_cells = find(strcmp(polarities, 'ON'));
off_cells = find(strcmp(polarities, 'OFF'));
none_cells = find(strcmp(polarities, 'NONE'));