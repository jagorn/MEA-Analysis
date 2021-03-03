function setH_Photo2MEA(exp_id, img_name, img_rf_name, mea_spacing_micron)

img_path = fullfile(processedPath(exp_id), img_name);
[H_img2mea, H_mea2img] = computeH_MEA2IMG(img_path, mea_spacing_micron);


% SAVE HOMOGRAPHIES
prompt = 'Do you want to save the homography? (1=YES, 0=NO)\n';
resp = input(prompt);


if resp == 1
    addHomography(H_img2mea, strcat('IMG_', img_rf_name), 'MEA', exp_id)
    addHomography(H_mea2img, 'MEA', strcat('IMG_', img_rf_name), exp_id)
    fprintf("Homographies have been saved.\n")
else
    fprintf("Homography have not been saved.\n")
end
close(f);







