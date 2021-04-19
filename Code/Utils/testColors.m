function testColors(n_colors)

colors = getColors(n_colors);

figure()
title('colors test')
hold on
labels = strings(1, n_colors);
for i_color = 1:n_colors
    rectangle('Position', [i_color-1, 1, 1, 1], 'FaceColor', colors(i_color, :), 'EdgeColor', 'None')
    labels(i_color) = strcat("color #", num2str(i_color));
end
xticks(0.5:1:n_colors)
xticklabels(labels)
yticks([])
