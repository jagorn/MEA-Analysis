function plotDHMEA(dh_sessions, img_type)
% dh_sessions = cell of dh_sessions id (in char)

l_elec = 30;  % units

if ~exist('img_type', 'var')
    img_type = 'mea';
end

exp_id = getExpId();
session_struct = load(getDatasetMat, dh_sessions{1});
i_session = session_struct.(dh_sessions{1}).sessions(1);

% COMPUTE HOMOGRAPHY             
H_img2mea = getHomography(['img' num2str(i_session)], 'mea', exp_id);
img_path = [dataPath '/' exp_id '/processed/DH/' img_type num2str(i_session) '.jpg'];
camera_img = imread(img_path);
[camera_img_proj, camera_mea_ref] = transformImage(H_img2mea, camera_img);

% PLOTTING TRANSFORMED POINTS
figure()

imshow(camera_img_proj, camera_mea_ref)
hold on


axis on
xticks(1:l_elec:l_elec*16)
xticklabels(0:15)
yticks(1:l_elec:l_elec*16)
yticklabels(0:15)
title("MEA Coordinates")


% ADD DH POINTS
colors = getColors(numel(dh_sessions));
for i_dh = 1:numel(dh_sessions)
    points = getDHSpotsCoordsMEA(dh_sessions{i_dh});
    color = colors(i_dh, :);
    scatter(points(:,1), points(:,2), 50, color, 'filled')
    text(points(:,1) + 2, points(:,2), string(1:size(points, 1)), 'Color', 'white')
end
legend(dh_sessions)
