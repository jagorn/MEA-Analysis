function matchSSTAs(indices1, indices2, colors)

load(getDatasetMat(), 'spatialSTAs', 'stas');

if ~exist("colors", "var")
    colors = getColors(3);
end

indices_only1 = find(indices1 & ~indices2);
indices_only2 = find(indices2 & ~indices1);
indices_both = find(indices1 & indices2);

colormap gray
y_size = size(stas{1}, 1);
x_size = size(stas{1}, 2);
background = ones(y_size, x_size) * 255;
image(background);
hold on

for i = indices_only1   
    [x, y] = spatialSTAs(i);
    plot(x, y, 'Color', colors(1, :), 'LineWidth', 1.5)
end

for i = indices_only2 
    [x, y] = spatialSTAs(i);
    plot(x, y, 'Color', colors(2, :), 'LineWidth', 1.5)
end

for i = indices_both
    [x, y] = spatialSTAs(i);
    plot(x, y, 'Color', colors(3, :), 'LineWidth', 1.5)
end

xlim([(x_size*.3), (x_size*.7)])
ylim([(y_size*.3), (y_size*.7)])
set(gca,'XTickLabel',[]);
set(gca,'YTickLabel',[]);