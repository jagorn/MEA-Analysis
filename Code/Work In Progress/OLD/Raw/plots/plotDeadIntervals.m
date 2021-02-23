function plotDeadIntervals(dead_init, dead_end, residual, time_spacing, stim_duration, mea_rate)

figure()

% Plot Stim
stim_rect = [0, 0, stim_duration/ mea_rate, max(residual)];
stim_color = [0, 0, 1, 0.3];
rectangle('Position', stim_rect, 'FaceColor', stim_color, 'LineStyle', 'none')

hold on

% Plot Residual
x_residual = (-time_spacing : length(residual)-time_spacing-1) / mea_rate;
plot(x_residual, residual, 'k')

% Plot Dead Invervals
for i = 1:length(dead_init)
    dead_interval_rect = [dead_init(i)/ mea_rate, 0, (dead_end(i) - dead_init(i))/ mea_rate, 300];
    di_color = [1, 0, 0, 0.3];
    rectangle('Position', dead_interval_rect, 'FaceColor', di_color, 'LineStyle', 'none')
end
