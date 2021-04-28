clear
close all

i_cell = 36;
color_idx = [1 2 4 7 9 15];
idx_patterns = 33:38;
exp_id = '20170614';


load(getDatasetMat, 'spatialSTAs', 'dh');
H1 = getHomography('dmd', 'img');
H2 = getHomography('img1', 'mea', exp_id);

sta = getSTAFrame(i_cell);
sta = floor(sta/max(sta(:)) * 255);

rf = spatialSTAs(i_cell);
rf.Vertices = transformPointsV(H2*H1, rf.Vertices);

spots_2mea = getDHSpotsCoordsMEA(exp_id);

patterns = dh.stimuli.test(idx_patterns, :);
n_patterns = size(patterns, 1);

colors = getColors(max(color_idx));
colors = colors(color_idx, :);


figure()

[sta_2mea, staRef_2mea] = transformImage(H2*H1, sta);
spots_2mea = getDHSpotsCoordsMEA(exp_id);

colorMap = [[linspace(0,1,128)'; ones(128,1)], [linspace(0,1,128)'; linspace(1,0,128)'] , [ones(128,1); linspace(1,0,128)']];
colormap(colorMap);

img_rgb = ind2rgb(sta_2mea, colormap('parula'));
imshow(img_rgb, staRef_2mea);
hold on
[x, y] = boundary(rf);
plot(x, y, 'k', 'LineWidth', 3)
% 
% 
% for i_p = 1:n_patterns
%     pattern = logical(patterns(i_p, :));
%     scatter(spots_2mea(pattern,1), spots_2mea(pattern,2), 50, colors(i_p, :), "Filled")
% end

pbaspect([1 1 1])
axis off
xlim([0, 500])
ylim([0, 500])


figure()
rect_color = [.9 .9 .9];
rect_edges = [0, 0, 500, 500];
rectangle('Position', rect_edges,'FaceColor', rect_color, 'EdgeColor', [1,1,1])

hold on

[x, y] = boundary(rf);
plot(x, y, 'k', 'LineWidth', 2)

for i_p = 1:n_patterns
    pattern = logical(patterns(i_p, :));
    scatter(spots_2mea(pattern,1), spots_2mea(pattern,2), 50, colors(i_p, :), "Filled")
end

pbaspect([1 1 1])
axis off
xlim([0, 500])
ylim([0, 500])
