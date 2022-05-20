function f = plotColorBar(color_bar, val_min, val_max, legend, figure_h)

n_colors = size(color_bar, 1);

if exist('figure_h', 'var')
    f = figure(figure_h);
else
    f = figure();
end
title(legend)
hold on

labels = strings(1, n_colors);
for i_color = 1:n_colors
    rectangle('Position', [i_color-1, 1, 1, 1], 'FaceColor', color_bar(i_color, :), 'EdgeColor', 'None')
    labels(i_color) = strcat("color #", num2str(i_color));
end
xticks(linspace(1, n_colors, 5))
xticklabels(linspace(val_min, val_max, 5))
yticks([])
xlabel(legend);

ss = get(0,'screensize');
width = ss(1, 3);
set(gcf,'Position',[width/2 - 400, 100, 800, 100]);