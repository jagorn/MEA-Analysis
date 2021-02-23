function plotCoverageMap(coverage, rfs_uniques, rfs_duplicates)

if all(coverage(:) < 0)
    error("empty RF coverage on this experiment")
end
[w, h] = size(coverage);
coverage_sature = min(coverage, 3);
row_max = max(coverage_sature, [], 1);
column_max = max(coverage_sature, [], 2);

x_edges = find(diff([-1 row_max -1]));
y_edges = find(diff([-1; column_max; -1]));

x_i = max(x_edges(1) -1, 1);
x_f = min(x_edges(end), w);
y_i = max(y_edges(1) -1, 1);
y_f = min(y_edges(end), h);

image(coverage_sature + 2);
colormap([0,0,0; 1,1,1; 0.9,0.9,0.4; 0.9,0.7,0.4; 0.9,0.4,0.4]);
c = colorbar('Ticks', 1.5:5.5, 'TickLabels', {'N/A', '0', '1', '2', '3+'});
c.Label.String = 'Coverage (number of RFs)';
hold on
for rf = rfs_uniques 
    [x, y] = boundary(rf);
    plot(x, y, 'Color', [0.6 0.6 0.6], 'LineWidth', 1.5)
end
for rf = rfs_duplicates  
    [x, y] = boundary(rf);
    plot(x, y, ':', 'Color', [0.3 0.3 0.3], 'LineWidth', 1.5)
end
xlim([x_i, x_f])
ylim([y_i, y_f])
axis off
