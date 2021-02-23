function plotDiscsResponses(i_cell, img_id, disc_diameter)

loadDataset();
exp_id = getExpId();
colors = getColors(numel(discs_reps));

% getting the info for the selected discs
disc_diam_idx = find([discs_reps.diameter] == disc_diameter);
distances = discs.distances(i_cell, disc_diam_idx);
areas = discs.overlaps(i_cell, disc_diam_idx);

% sort the discs by distance or overlap
[v_areas, idx_by_areas] = sort(areas, 'descend');
[~, idx_by_distance] = sort(distances, 'ascend');
sorted_idx = [idx_by_areas(v_areas>0) idx_by_distance(areas(idx_by_distance)<=0)];
disc_idx = disc_diam_idx(sorted_idx);

% create labels
labels = strings(1, numel(disc_idx));
for i_disc_idx = 1:numel(disc_idx)
    i_disc = disc_idx(i_disc_idx);
    disc_id = char(discs_reps(i_disc).id);
    labels(i_disc_idx) = [disc_id ':  ' num2str(round(discs.distances(i_cell, i_disc))) 'um'];
end


figure()
fullScreen();

% plot Receptive Field with discs on it
subplot(3, 4, [7 8 11 12])
plotSTAwithDiscs(i_cell, discs_reps, img_id, disc_idx, colors)
title(['cell#' num2str(i_cell) ', disc_diam=' num2str(disc_diameter)], 'Interpreter', 'None')

% plot temporal STA
subplot(3, 6, 5)
plotTSTAs(i_cell);
title('temporal STA')

% plot the PSTHS, with discs sorted by distance/overlap
subplot(3, 4, [2 6 10]);
plotDiscsPsths(i_cell, discs, disc_idx, colors, labels)
base = num2str(round(discs.avg_base(i_cell)/discs.params.time_bin));
tr_up = num2str(round(discs.tresh_up(i_cell)/discs.params.time_bin));
tr_down = num2str(round(discs.tresh_down(i_cell)/discs.params.time_bin));

title(['PSTH (avg=' base 'Hz, ta=' tr_up ', td=' tr_down ')'])

% plot the Rasters, with discs sorted by distance/overlap
subplot(3, 4, [1 5 9])

reps = {discs_reps(disc_idx).rep_begin};
onset =  discs.params.initial_offset;
offset = discs.stim_duration + discs.params.final_offset;

edges_onset = [discs.dt_black2(1)];
edges_offset = [discs.dt_black2(2)];

plotStimRaster(spikes{i_cell},  reps, discs.stim_duration*params.meaRate, params.meaRate, ...
                'Raster_Colors', colors(disc_idx, :), ...
                'Labels', labels, ...
                'Response_Onset_Seconds', onset, ...
                'Response_Offset_Seconds', offset, ...
                'Edges_Onset_Seconds', edges_onset, ...
                'Edges_Offset_Seconds', edges_offset);
title('Raster')