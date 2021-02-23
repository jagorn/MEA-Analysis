% function plotDHWeights_RF(i_cell, experiment)
close all

i_cell = 43;
experiment = "20170614";
camera_img = imread('dh_spots.jpg');

load(getDatasetMat, "stas");
smoothSTA = smoothSta(stas{i_cell});
dmd_img = std(stas{i_cell}, [], 3);

h = getHomography('img', 'dmd');
[t_camera_img, t_ref] = transformImage(h, camera_img);

load([dataPath '/' char(experiment) '/processed/DH/DHFrames_1.mat'], "PatternImage");
[t_points_x, t_points_y] = transformPoints(h, PatternImage(:,1), PatternImage(:,2));

figure
imshow_0(dmd_img/max(dmd_img(:)));
hold on
imshow(t_camera_img, t_ref);

title("mine");

xlim([-100, 100]);
ylim([-100, 100]);
axis on

scatter(t_points_x, t_points_y, 5, "Filled")

