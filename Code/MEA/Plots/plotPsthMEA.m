function plotPsthMEA(psths, offset, period, mea_positions)
    
[n_elecs, n_steps] = size(psths);
max_psth = max(psths(:));

hold on
% axis off

for i_elec = 1:n_elecs
        
    x_norm = [1/n_steps:1/n_steps:1] - 0.5/n_steps;
    y_norm = squeeze(psths(i_elec, :) / max_psth);
    
    x_pos = mea_positions(i_elec, 1) - 0.5;
    y_pos = mea_positions(i_elec, 2) - 0.5;
    
    x_plot = x_norm + x_pos;
    y_plot = y_norm + y_pos;
    
    stairs(x_plot, y_plot, 'k')  
    
    onset_plot = x_pos + offset/period;
    offset_plot = x_pos + (period - offset)/period;

    plot([onset_plot, onset_plot], [y_pos, y_pos + 1], 'g--', 'LineWidth', 1);
    plot([offset_plot, offset_plot], [y_pos, y_pos + 1], 'r--', 'LineWidth', 1);
end

