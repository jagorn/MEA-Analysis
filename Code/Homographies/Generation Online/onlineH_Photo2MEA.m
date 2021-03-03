function [H_img2mea, H_mea2img] = setH_Photo2MEA(img_path, mea_spacing_micron)

% LOAD THE MEA IMAGE
try
    camera_img = imread(img_path);
catch
    error_struct.message = strcat("image ", img_path, " do not exist");
    error_struct.identifier = strcat('MEA_Analysis:', mfilename);
    error(error_struct);
end

% PLOT THE MEA IMAGE
f = figure();
fullScreen()

subplot(1,2,1);
imshow(camera_img)
hold on
axis on
title("Image Coordinates")

% COLLECT POINT INTERACTIVELY
anchors_image = ones(3, 5);
anchors_MEA = ones(3, 5);
for i_point = 1:5
    figure(f)
    xlabel('MEA COLUMNS (1 ==> 16)');
    ylabel('MEA ROWS (1 ==> 16)');
    fprintf("%i/5: CLICK ON AN ELECTRODE ON THE IMAGE\n", i_point);
    anchors_image(1:2, i_point) = ginput(1);
    scatter(anchors_image(1, i_point), anchors_image(2, i_point), 'r*');
    prompt = ['Anchor ' int2str(i_point) ': enter ROW number (from 1 to 16)\n'];
    anchors_MEA(2, i_point) = input(prompt) * mea_spacing_micron;
    prompt = ['Anchor ' int2str(i_point) ': enter COLUMN number (from 1 to 16)\n'];
    anchors_MEA(1, i_point) = input(prompt) * mea_spacing_micron;
end
fprintf("Generating Homography...")

% COMPUTE HOMOGRAPHY             
origin_MEA = [8.5*mea_spacing_micron; 8.5*mea_spacing_micron; 1];
H_img2mea = anchors_MEA * pinv(anchors_image);
H_mea2img = anchors_image * pinv(anchors_MEA);
[camera_img_proj, camera_mea_ref] = transformImage(H_img2mea, camera_img);

% TRANSFORMING POINTS
anchors_MEA_proj = H_mea2img * anchors_MEA;
anchors_MEA_proj = anchors_MEA_proj ./ anchors_MEA_proj(3,:);

anchors_image_proj = H_img2mea * anchors_image;
anchors_image_proj = anchors_image_proj ./ anchors_image_proj(3,:);

origin_proj =  H_mea2img * origin_MEA;
origin_proj = origin_proj ./ origin_proj(3,:);

% PLOTTING TRANSFORMED POINTS
figure(f)
subplot(1,2,1);
hold on
scatter(anchors_image(1,:), anchors_image(2,:), 'r*')
scatter(anchors_MEA_proj(1,:), anchors_MEA_proj(2,:), 'go')
scatter(origin_proj(1,:), origin_proj(2,:), 'wx')

subplot(1,2,2);
imshow(camera_img_proj, camera_mea_ref)
hold on
scatter(anchors_image_proj(1,:), anchors_image_proj(2,:), 'r*')
scatter(anchors_MEA(1,:), anchors_MEA(2,:), 'go')
scatter(origin_MEA(1,:), origin_MEA(2,:), 'wx')

axis on
xticks(1:mea_spacing_micron:mea_spacing_micron*16)
xticklabels(0:15)
yticks(1:mea_spacing_micron:mea_spacing_micron*16)
yticklabels(0:15)
title("MEA Coordinates")








