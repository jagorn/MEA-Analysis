function plotSTAwithDiscs(i_cell, discs_reps, img_id, disc_idx, colors)

exp_id = getExpId();

% get STA and transform it
sta = getSTAFrame(i_cell);
sta = floor(sta/max(sta(:)) * 100);
H1 = getHomography('dmd', 'img');
H2 = getHomography(['img' num2str(img_id)], 'mea', exp_id);
[sta_2mea, staRef_2mea] = transformImage(H2*H1, sta);

% get Receptive Field and transform it
load(getDatasetMat, "spatialSTAs");
rf = spatialSTAs(i_cell);
rf.Vertices = transformPointsV(H2*H1, rf.Vertices);    
[rf_x, rf_y] = boundary(rf);

% Receptive field first..
img_rgb = ind2rgb(sta_2mea, colormap(summer));
imshow(img_rgb, staRef_2mea);
hold on
plot(rf_x, rf_y, 'k', 'LineWidth', 3);

% ..then all the discs
for i_disc_idx = 1:numel(disc_idx)
    i_disc = disc_idx(i_disc_idx);
    disc_x = discs_reps(i_disc).center_x_mea;
    disc_y = discs_reps(i_disc).center_y_mea;
    disc_r = discs_reps(i_disc).diameter/2;
    disc_id = char(discs_reps(i_disc).id);
    
    % add also the id text so they can be matched to the raster plots
	viscircles([disc_x, disc_y], disc_r, 'Color', colors(i_disc, :));
    text(disc_x, disc_y, disc_id, 'HorizontalAlignment', 'center', 'Color', colors(i_disc, :))
end

xlabel('Microns');
ylabel('Microns');