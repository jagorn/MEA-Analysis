exp_id = '20190510';
fv = 1;

mea_rf = 'mea';
img_rf = ['img' num2str(fv)];

dh_spots_img = imread([dataPath '/' exp_id '/processed/DH/dh' num2str(fv) '_spots.jpg']);
dh_mea_img = imread([dataPath '/' exp_id '/processed/DH/dh' num2str(fv) '_mea.jpg']);
camera_img = cat(3, dh_mea_img, dh_spots_img, dh_mea_img);
points = getDHSpotsCoordsImg(exp_id, fv);
poins_homo = [points'; ones(1, size(points, 1))];

% COMPUTE HOMOGRAPHY
l_elec = 30;  % units

anchors_image =   [47, 126, 309, 482, 581;
                   498, 183, 316, 83, 398;
                   1, 1, 1, 1, 1]
               
anchors_MEA =   [ [4, 11, 8, 13, 6]  * l_elec;
                  [15, 13, 9, 5, 3] * l_elec;
                  [1, 1, 1, 1,  1]  ]
              
origin_MEA = [7.5*l_elec; 7.5*l_elec; 1];
         

H_img2mea = anchors_MEA * pinv(anchors_image);
H_mea2img = anchors_image * pinv(anchors_MEA);

addHomography(H_img2mea, img_rf, mea_rf, exp_id)
addHomography(H_mea2img, mea_rf, img_rf, exp_id)

% test
anchors_MEA_proj = H_mea2img * anchors_MEA;
anchors_MEA_proj = anchors_MEA_proj ./ anchors_MEA_proj(3,:);

anchors_image_proj = H_img2mea * anchors_image;
anchors_image_proj = anchors_image_proj ./ anchors_image_proj(3,:);

origin_proj =  H_mea2img * origin_MEA;
origin_proj = origin_proj ./ origin_proj(3,:);

poins_proj = H_img2mea * poins_homo;
poins_proj = poins_proj ./ poins_proj(3,:);

[camera_img_proj, camera_mea_ref] = transformImage(H_img2mea, camera_img);

figure()
subplot(1,2,1);
imshow(camera_img)
hold on
scatter(anchors_image(1,:), anchors_image(2,:), 'r*')
scatter(anchors_MEA_proj(1,:), anchors_MEA_proj(2,:), 'go')
scatter(origin_proj(1,:), origin_proj(2,:), 'wx')
scatter(poins_homo(1, :), poins_homo(2, :), 'y', 'filled')

axis on
title("Image Coordinates")

subplot(1,2,2);
imshow(camera_img_proj, camera_mea_ref)
hold on
scatter(anchors_image_proj(1,:), anchors_image_proj(2,:), 'r*')
scatter(anchors_MEA(1,:), anchors_MEA(2,:), 'go')
scatter(origin_MEA(1,:), origin_MEA(2,:), 'wx')
scatter(poins_proj(1, :), poins_proj(2, :), 'y', 'filled')

axis on
xticks(0:l_elec:l_elec*15)
xticklabels(0:15)
yticks(0:l_elec:l_elec*15)
yticklabels(0:15)


title("MEA Coordinates")

