clc;
clear;
close all;

% load('/home/fran_tr/Projects/MEA-Analysis/Articles/Typing/Classification/typing_results.mat', 'rfs')
% load('/home/fran_tr/Projects/MEA-Analysis/Articles/Typing/Classification/typing_results.mat', 'stas')
% load('/home/fran_tr/Projects/MEA-Analysis/Articles/Typing/typing_data.mat', 'spatialSTAs')
% load('/home/fran_tr/Projects/MEA-Analysis/Articles/Typing/typing_data.mat', 'temporalSTAs')
% 
% [new_tempo, new_spatio, new_rfs, new_indices] = decomposeSTA(stas, 'Do_Smoothing', false, 'Remove_Surround', true);
% [old_tempo, old_spatio, old_rfs, old_indices] = decomposeSTA(stas, 'Do_Smoothing', false, 'Remove_Surround', false);
% 
% save("/home/fran_tr/Projects/MEA-Analysis/Articles/Typing/Test Surround/testSurround");
load("/home/fran_tr/Projects/MEA-Analysis/Articles/Typing/Test Surround/testSurround");

n_cells = numel(new_rfs);

% Rescale RFs
for i_cell = 1:n_cells
    new_rfs(i_cell).Vertices = new_rfs(i_cell).Vertices * 50;  % scale to microns
    old_rfs(i_cell).Vertices = old_rfs(i_cell).Vertices * 50;  % scale to microns
end

% exclude bad ones
too_small = (area(old_rfs) < 1.5) | (area(new_rfs) < 1.5);
too_bad = all(~old_tempo') | all(~new_tempo');
valid = ~ (too_small | too_bad);

% what to compare? AREA SIZE, TEMPORAL PROFILE
% how to comare? pearson correlation, 

% Area size
old_areas = area(old_rfs(valid));
new_areas = area(new_rfs(valid));

area_se = (old_areas - new_areas).^2;
area_me = mean(abs(old_areas - new_areas));
area_rmse = sqrt(mean(area_se));

mean_old_areas = mean(old_areas); 
mean_new_areas = mean(new_areas); 

% Centroid Position
[old_x, old_y] = centroid(old_rfs(valid));
[new_x, new_y] = centroid(new_rfs(valid));

centroid_distance = sqrt((old_x - new_x).^2 + (old_y - new_y).^2);

distance_me = mean(centroid_distance);
distance_rmse = sqrt(mean(centroid_distance.^2));

% Temporal Profile
p_sum = 0;
for i_v = find(valid)
    pM = corrcoef(new_tempo(i_v, :), old_tempo(i_v, :));
    p_sum = pM(1, 2) + p_sum;
end
p = p_sum / sum(valid);

fprintf("OLD AREAS AVG = %f, NEW AREAS AVG = %f\n", mean_old_areas, mean_new_areas);
fprintf("AREA MAE = %f, RMSE = %f\n", area_me, area_rmse);
fprintf("DISTANCE MAE = %f, DISTANCE RMSE = %f\n", distance_me, distance_rmse);
fprintf("TEMPO CORRCOEF = %f\n\n", p);

% [sse, i] = sort(abs(old_areas - new_areas));
% vv = find(valid);
% iii = flip(vv(i));

% plots
% for i_cell = iii
%     old_frame = squeeze(old_spatio(i_cell, :, :));
%     new_frame = squeeze(new_spatio(i_cell, :, :));
%     
%     old_tsta = squeeze(old_tempo(i_cell, :));
%     new_tsta = squeeze(new_tempo(i_cell, :));
%     
%     old_rf = old_rfs(i_cell);
%     new_rf = new_rfs(i_cell);
%     
%     figure();
%     fullScreen();
%     
%     subplot(1, 3, 1);load("/home/fran_tr/Projects/MEA-Analysis/Articles/Typing/Test Surround/testSurround");
% 
%     imagesc(old_frame);
%     daspect([1, 1, 1]);
%     hold on;
%     plot(old_rf, 'EdgeColor', 'r');
%     title(area(old_rf));
%     
%     subplot(1, 3, 2);
%     imagesc(new_frame);
%     daspect([1, 1, 1]);
%     hold on;
%     plot(old_rf, 'EdgeColor', 'r');
%     plot(new_rf, 'EdgeColor', 'g');
%     title(area(new_rf));
% 
%     subplot(1, 3, 3);
%     hold on;
%     plot(old_tsta, 'r');
%     plot(new_tsta, 'g');
%     ylim([0, 1]);
%     title("Temporal");
%     
%     waitforbuttonpress();
%     close();
% end