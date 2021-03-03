function setH_CameraCenter10x2MEA()

img_path = fullfile(getH_ImagesPath(), 'c10.tif');
camera_ref_name = 'CAMERA_X10';
mea_spacing_micron = 30;

% LOAD THE MEA IMAGE
tx10 = Tiff(img_path);
imgx10 = read(tx10);
[H_img2mea, H_mea2img] = onlineH_Photo2MEA(imgx10, mea_spacing_micron);


% SAVE HOMOGRAPHIES
prompt = 'Do you want to save the homography? (1=YES, 0=NO)\n';
resp = input(prompt);


if resp == 1
    addHomography(H_img2mea, camera_ref_name, 'MEA', exp_id)
    addHomography(H_mea2img, 'MEA', camera_ref_name, exp_id)
    fprintf("Homographies have been saved.\n")
else
    fprintf("Homography have not been saved.\n")
end
close(f);