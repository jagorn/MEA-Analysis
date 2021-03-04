function setH_CameraCenter10x2MEA()

img_path = fullfile(getH_ImagesPath(), 'camera_center_x10.jpg');
camera_ref_name = 'CAMERA_X10';
mea_spacing_micron = 30;

% LOAD THE MEA IMAGE
camera_img = imread(img_path);
[H_img2mea, H_mea2img] = onlineH_Photo2MEA(camera_img, mea_spacing_micron);


% SAVE HOMOGRAPHIES
prompt = 'Do you want to save the homography? (1=YES, 0=NO)\n';
resp = input(prompt);


if resp == 1
    addHomography(H_img2mea, camera_ref_name, 'MEA')
    addHomography(H_mea2img, 'MEA', camera_ref_name)
    fprintf("Homographies have been saved.\n")
else
    fprintf("Homography have not been saved.\n")
end