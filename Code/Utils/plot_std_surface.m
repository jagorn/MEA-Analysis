function p = plot_std_surface(ys, x, color)

avgY = mean(ys, 1);
stdY = std(ys, [], 1);
stdY_up = avgY + stdY/2;
stdY_down = avgY - stdY/2;

x_plot = [x, fliplr(x)];
y_plot = [stdY_up, fliplr(stdY_down)];

x_plot(isnan(y_plot)) = [];
y_plot(isnan(y_plot)) = [];

fill(x_plot, y_plot, color, 'EdgeColor', 'None', 'facealpha', 0.5);
p = plot(x, avgY, 'Color', color, 'LineWidth', 2);
scatter(x, avgY,  15, color, 'Filled');
end