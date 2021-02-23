i_cell = 38;
experiment = '20170614';
changeDataset("20170614")
camera_img = imread('dh_spots.jpg');

spots_coords_image = getDHSpotsCoordsImg(experiment, 1);
w = getDHLNPWeights(experiment, i_cell);
[accuracy, loss] = getDHLNPAccuracies(experiment)

dmd_img = getSTAFrame(i_cell);
h = getHomography('dmd', 'img');
[dmd_img_2img, dmd_ref_2img] = transformImage(h, dmd_img);

figure
imshow(dmd_img_2img/max(dmd_img_2img(:)), dmd_ref_2img);
hold on
imshow_0(camera_img);
hold on

colorMap = [[linspace(0,1,128)'; ones(128,1)], [linspace(0,1,128)'; linspace(1,0,128)'] , [ones(128,1); linspace(1,0,128)']];
colorCodes = ceil(w*127.5 + 128.5);
colors = colorMap(colorCodes, :);
scatter(spots_coords_image(:,1), spots_coords_image(:,2), 30, colors, "Filled")
axis on
