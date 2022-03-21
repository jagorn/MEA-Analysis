clear
close all
clc

% Load Images
img_path_10x = fullfile(getH_ImagesPath(), 'camera_center_x10.jpg');
img_path_40x = fullfile(getH_ImagesPath(), 'camera_center_x40.jpg');

camera_img_10x = double(imread(img_path_10x));
camera_img_40x = double(imread(img_path_40x));

camera_img_10x = camera_img_10x / max(camera_img_10x(:));
camera_img_40x = camera_img_40x / max(camera_img_40x(:));

% Load Checkerboard Frame
checker_path = fullfile(getH_ImagesPath(), 'checker_example.mat');
load(checker_path, 'checker');
checker = checker / max(checker(:));

% Load Homographies
Hx10_2_MEA = getHomography('CAMERA_X10', 'MEA');
Hx40_2_MEA = getHomography('CAMERA_X40', 'MEA');

HChecker_2_DMD = getHomography('CHECKER20', 'DMD');
HDMD_2_Camera = getHomography('DMD', 'CAMERA');

% Compose Homographies
HChecker_2_MEA = Hx10_2_MEA * HDMD_2_Camera * HChecker_2_DMD;

% Transform Images
[mea_img_x10, ref_mea_x10] = transformImage(Hx10_2_MEA, camera_img_10x);
[mea_img_x40, ref_mea_x40] = transformImage(Hx40_2_MEA, camera_img_40x);

% Transform Checkerboard
[mea_checker, ref_mea_checker] = transformImage(HChecker_2_MEA, checker);

% Add colors and opacity
mea_img_x10_color = cat(3, mea_img_x10, mea_img_x10, mea_img_x10);
mea_img_x40_color = cat(3, mea_img_x40*0.8, mea_img_x40*0.8, mea_img_x40);
mea_checker_color = cat(3, mea_checker*0.2, mea_checker, mea_checker*0.2);


% Plot
figure();
imshow(mea_img_x10_color, ref_mea_x10)
hold on
imshow(mea_img_x40_color, ref_mea_x40)
hold on
plotElectrodesMEA();
m = imshow(mea_checker_color, ref_mea_checker);
set(m, 'AlphaData', 0.3);


