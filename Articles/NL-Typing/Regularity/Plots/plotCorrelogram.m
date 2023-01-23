function plotCorrelogram(er)

hold on
daspect([1 1 1]);
scatter(0, 0, 15, 'b+');
scatter(er.points(:, 1), er.points(:, 2), 15, 'Filled', ...
    'MarkerFaceColor', 'red', ...
    'MarkerFaceAlpha', 0.75, ...
    'MarkerEdgeColor', 'None');

for section = er.sections'
    plot(section, 'FaceColor', 'None');
end

xmin = min(section.Vertices(:, 1));
xmax = max(section.Vertices(:, 1));
ymin = min(section.Vertices(:, 2));
ymax = max(section.Vertices(:, 2));
xlim([xmin xmax]);
ylim([ymin ymax]);

xlabel('distance [\mum]');
ylabel('distance [\mum]');