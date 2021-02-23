function plotPsthDhGrid(single_psths, max_psth, evt_positions, offset, period)
    
[~, n_patterns, n_steps] = size(single_psths);

hold on
axis off

for i_evt = 1:n_patterns
        
    x_norm = [1/n_steps:1/n_steps:1] - 0.5/n_steps;
    y_norm = squeeze(single_psths(:, i_evt, :) / max_psth);
    
    x_pos = evt_positions(i_evt, 1) - 0.5;
    y_pos = -evt_positions(i_evt, 2) - 0.5;
    
    x_plot = x_norm + x_pos;
    y_plot = y_norm + y_pos;
    
    rectangle('Position', [x_pos, y_pos, 1, 1], 'FaceColor', 'w')
    plot(x_plot, y_plot, 'k')  
    
    onset_plot = x_pos + offset/period;
    offset_plot = x_pos + (period - offset)/period;

    plot([onset_plot, onset_plot], [y_pos, y_pos + 1], 'g--', 'LineWidth', 1);
    plot([offset_plot, offset_plot], [y_pos, y_pos + 1], 'r--', 'LineWidth', 1);
end

