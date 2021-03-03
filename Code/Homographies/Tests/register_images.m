close all
clear

exp_id = '20190510';
dh_mea1_img = imread([dataPath '/' exp_id '/processed/DH/dh1_mea.jpg']);
dh_mea4_img = imread([dataPath '/' exp_id '/processed/DH/dh4_mea.jpg']);

dh_points1 = getDHSpotsCoordsImg(exp_id, 1);
dh_points4 = getDHSpotsCoordsImg(exp_id, 4);

micron_points1 = getDHSpotsPositions(exp_id, 1);
micron_points4 = getDHSpotsPositions(exp_id, 4);

H_img1_mea = getHomography('img1', 'mea', exp_id);
H_img4_mea = getHomography('img4', 'mea', exp_id);

[dh_mea1_proj, dh_mea1_ref] = transformImage(H_img1_mea, dh_mea1_img);
[dh_mea4_proj, dh_mea4_ref] = transformImage(H_img4_mea, dh_mea4_img);

[t_x1s, t_y1s] = transformPoints(H_img1_mea, dh_points1(:, 1), dh_points1(:, 2));
dh_points1_mea = [t_x1s; t_y1s]';

[t_x4s, t_y4s] = transformPoints(H_img4_mea, dh_points4(:, 1), dh_points4(:, 2));
dh_points4_mea = [t_x4s; t_y4s]';

figure()
imshow(dh_mea4_proj, dh_mea4_ref)
hold on
imshow(dh_mea1_proj, dh_mea1_ref)
hold on

scatter(dh_points1_mea(:, 1), dh_points1_mea(:, 2), 'r', 'filled')
scatter(dh_points4_mea(:, 1), dh_points4_mea(:, 2), 'g', 'filled')

axis on
xlim([-100, 500])
ylim([0, 400])
title("registration of points")

figure()
scatter(micron_points1(:, 1), micron_points1(:, 2), 'r', 'filled')
hold on
scatter(micron_points4(:, 1), micron_points4(:, 2), 'g', 'filled')