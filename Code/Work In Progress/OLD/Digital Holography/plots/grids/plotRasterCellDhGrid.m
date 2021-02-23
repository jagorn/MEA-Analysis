function plotRasterCellDhGrid(spikes, evts, evt_duration, evt_spacing, evt_positions, mea_rate, n_max_rep)
    
evt_tot_duration = evt_duration + evt_spacing*2;
evt_tot_time = evt_tot_duration / mea_rate;

hold on
axis off
ax = gca;
ax.YDir = 'reverse';

for i_evt = 1:numel(evts)
    evt_times = evts{i_evt};
    
    [x, y] = raster(spikes, evt_times - evt_spacing, evt_times + evt_duration + evt_spacing, mea_rate);
    
    x_norm = x / evt_tot_time;
    y_norm = y / n_max_rep;
    
    x_plot = x_norm + evt_positions(i_evt, 1) - 0.5;
    y_plot = y_norm + evt_positions(i_evt, 2) - 0.5;
    
    rectangle('Position', [evt_positions(i_evt, 1) - 0.5, evt_positions(i_evt, 2) - 0.5, 1, 1], 'FaceColor', 'w')
    scatter(x_plot, y_plot, 30, 'k', '.')  
    
    onset_plot = evt_positions(i_evt, 1) - 0.5 + evt_spacing/evt_tot_duration;
    offset_plot = evt_positions(i_evt, 1) + 0.5 - evt_spacing/evt_tot_duration;

    plot([onset_plot, onset_plot], [evt_positions(i_evt, 2) + 0.5, evt_positions(i_evt, 2) - 0.5], 'g--', 'LineWidth', 1);
    plot([offset_plot, offset_plot], [evt_positions(i_evt, 2) + 0.5, evt_positions(i_evt, 2) - 0.5], 'r--', 'LineWidth', 1);
end

