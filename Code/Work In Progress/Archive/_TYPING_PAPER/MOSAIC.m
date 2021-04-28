close all
clear

class_id = 'RGC.8.2.4_PRUNED';
exp_id =  '20181017';

% load Dataset variables
load(getDatasetMat, 'spatialSTAs', 'stas', 'classesTable', 'experiments');
idx = classExpIndices(class_id, exp_id);
[idx_uniques, idx_duplicates] = filterDuplicates(idx);

% load the mosaic statistics for [class_id] in [exp_id]
[nnnds, null_nnnds] = getClassNNNDs(class_id, exp_id);

rfs = spatialSTAs(idx_uniques);

y_size = size(stas{1}, 1);
x_size = size(stas{1}, 2);

figure()
hold on

for i = 1:size(rfs, 2)  
    [x, y] = boundary(rfs(i));
    plot(x, y, 'k', 'LineWidth', 1.5)
end

pbaspect([1 1 1])
xlim([(x_size*.2), (x_size*.8)])
ylim([(y_size*.2), (y_size*.8)])
title('receptive field')


figure()
histogram(null_nnnds(:), -0.125:0.25:5.125, ...
    'Normalization','probability', ... 
    'DisplayStyle', 'stairs', ...
    'LineStyle', '--', ...
    'LineWidth', 1.5, ...
    'EdgeColor', 'k');
hold on

histogram(nnnds(:), -0.125:0.25:5.125, ...
    'Normalization','probability'...
    );
xlabel("Normalized Nearest Neighbor Distances");
ylabel("Frequency");
ylim([0 1.1]);
xlim([0 3]);
