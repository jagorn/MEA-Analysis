function setH_Photo2MEA(exp_id, img_name, img_rf_name, mea_spacing_micron)

if ~exist('mea_spacing_micron', 'var')
    mea_spacing_micron = 30;
end

% LOAD THE MEA IMAGE
try
    img_path = fullfile(processedPath(exp_id), img_name);
    camera_img = imread(img_path);
catch
    error_struct.message = strcat("image ", img_path, " do not exist");
    error_struct.identifier = strcat('MEA_Analysis:', mfilename);
    error(error_struct);
end

[H_img2mea, H_mea2img] = onlineH_Photo2MEA(camera_img, mea_spacing_micron);


% SAVE HOMOGRAPHIES
prompt = 'Do you want to save the homography? (1=YES, 0=NO)\n';
resp = input(prompt);


if resp == 1
    addHomography(H_img2mea, strcat('CAMERA_', img_rf_name), 'MEA', exp_id)
    addHomography(H_mea2img, 'MEA', strcat('CAMERA_', img_rf_name), exp_id)
    fprintf("Homographies have been saved.\n")
else
    fprintf("Homography have not been saved.\n")
end
close(f);







