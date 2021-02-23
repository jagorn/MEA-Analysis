close all
clear

image_path = 'dh_spots_20170614.jpg';

camera_img = imread(image_path);
[camera_height, camera_width, ~] = size(camera_img);

load(getDatasetMat, "stas");
[dmd_height, dmd_width, ~] = size(stas{1});

Camera_PxlSize = 0.64;
DMD_PxlSize = 2.5;
Checkerboard_PxlsPerSquare = 20;
Square_PxlSize = DMD_PxlSize * Checkerboard_PxlsPerSquare;

s = Square_PxlSize/Camera_PxlSize;
r = pi/2;

H1 = [1, 0, -dmd_width/2; ...
      0, 1, -dmd_height/2; ...
      0, 0, 1];
         
H2 = [+cos(r), -sin(r), 0; ...
      +sin(r), +cos(r), 0; ...
      0,       0,       1];
  
H3 = [s, 0, 0; ...
      0, s, 0; ...
      0, 0, 1];

H4 = [1, 0, camera_width/2; ...
      0, 1, camera_height/2; ...
      0, 0, 1];

H_dmd2img = H4*H3*H2*H1;
H_img2dmd = inv(H_dmd2img);

addHomography(H_dmd2img, 'dmd', 'img')
addHomography(H_img2dmd, 'img', 'dmd')