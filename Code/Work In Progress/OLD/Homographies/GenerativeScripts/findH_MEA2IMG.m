function findH_MEA2IMG(exp_id, img_name, dh_groups)
l_elec = 30;  % units

% LOAD THE MEA IMAGE
try
    img_path = [dataPath '/' exp_id '/processed/DH/' img_name '.jpg'];
    camera_img = imread(img_path);
catch
    error("MEA image %s do not exist", img_path)
end

% PLOT THE MEA IMAGE
f = figure();
subplot(1,2,1);
imshow(camera_img)
hold on
axis on
title("Image Coordinates")
try
    ss = get(0,'MonitorPositions'); % try to get the secondary monitor
    x_0 = ss(2, 1);
    y_0 = ss(2, 2);
    width = ss(2, 3);
    height = ss(2, 4);
    set(gcf,'Position',[x_0, y_0, width, height]);
catch
    ss = get(0,'screensize');
    width = ss(3);
    height = ss(4);
    set(gcf,'Position',[0, 0, width, height]);
end

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
    anchors_MEA(2, i_point) = input(prompt) * l_elec;
    prompt = ['Anchor ' int2str(i_point) ': enter COLUMN number (from 1 to 16)\n'];
    anchors_MEA(1, i_point) = input(prompt) * l_elec;
end
fprintf("Generating Homography...")

% COMPUTE HOMOGRAPHY             
origin_MEA = [8.5*l_elec; 8.5*l_elec; 1];
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
xticks(1:l_elec:l_elec*16)
xticklabels(0:15)
yticks(1:l_elec:l_elec*16)
yticklabels(0:15)
title("MEA Coordinates")


% ADD DH POINTS
try
    points = getDHSpotsCoordsImg(exp_id, dh_groups(1));
    poins_homo = [points'; ones(1, size(points, 1))];

    poins_proj = H_img2mea * poins_homo;
    poins_proj = poins_proj ./ poins_proj(3,:);

    figure(f)
    subplot(1,2,1);
    scatter(poins_homo(1, :), poins_homo(2, :), 'y', 'filled')
    subplot(1,2,2);
    scatter(poins_proj(1, :), poins_proj(2, :), 'y', 'filled')

catch e
    fprintf("WARNING: not possible to retrieve the DH spots\n")
    fprintf("%s: %s\n\n", e.identifier, e.message)
end

% SAVE HOMOGRAPHIES
prompt = 'Do you want to save the homography? (1=YES, 0=NO)\n';
resp = input(prompt);

if resp == 1
    for i_group = dh_groups
        img_rf = ['img' num2str(i_group)];
        addHomography(H_img2mea, img_rf, 'mea', exp_id)
        addHomography(H_mea2img, 'mea', img_rf, exp_id)
    end
    fprintf("Homographies have been saved.\n")
else
    fprintf("Homography have not been saved.\n")
end
close(f);







