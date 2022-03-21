function plotFluoCard(exp_id, holo_section_id, cell_ids, spot_id, varargin)


% Parse Input
p = inputParser;
addRequired(p, 'exp_id');
addRequired(p, 'holo_section_id');
addRequired(p, 'cell_ids');
addRequired(p, 'spot_ids');
addParameter(p, 'Cell_Colors', []);

parse(p, exp_id, holo_section_id, cell_ids, spot_id, varargin{:});
cell_colors = p.Results.Cell_Colors;

s = getHoloSection(exp_id, holo_section_id);
spot_position = s.positions.mea(spot_id, :);
h_camera_ref = s.h_ref;
image_file = s.image;
image = imread(image_file);

[temporal, spatial, rfs, valid] = getSTAsComponents(exp_id);
for cell_id = cell_ids(:)'
    if ~ismember(cell_id, valid)
        warning(strcat('Cell #', num2str(cell_id), ' does not have a valid STA'));
    end
end

if isempty(cell_colors)
    cell_labels = 1:numel(cell_ids);
    hues = linspace(1/3, 1, numel(cell_ids));
    sat = 0.5 * ones(1, numel(cell_ids));
    val = 1.0 * ones(1, numel(cell_ids));
    cell_colors = hsv2rgb([hues; sat; val]');
end

% Load Homographies
HDMD_2_Camera = getHomography('DMD', 'CAMERA');
HCamera_2_MEA_Fix = getHomography('CAMERA_X10', 'MEA');
HCamera_2_MEA_Fluo = getHomography(h_camera_ref, 'MEA', exp_id);
HChecker_2_DMD = getHomography('CHECKER20', 'DMD');

% Compose Homographies
HChecker_2_MEA = HCamera_2_MEA_Fix * HDMD_2_Camera * HChecker_2_DMD;
[img_2mea, imgRef_2mea] = transformImage(HCamera_2_MEA_Fluo, image);

% Plot
figure();
imshow(img_2mea, imgRef_2mea);
hold on
scatter(spot_position(:, 1), spot_position(:, 2), 50, 'yellow', 'Filled');

% Receptive Fields
for i_cell = 1:numel(cell_ids)
    cell_id = cell_ids(i_cell);
    cell_label = cell_labels(i_cell);
    cell_color = cell_colors(i_cell, :);
    
    rf = rfs(cell_id);
    rf.Vertices = transformPointsV(HChecker_2_MEA, rf.Vertices);
    [x, y] = boundary(rf);
    [cx, cy] = centroid(rf);
    
    plot(x, y, 'Color', cell_color, 'LineWidth', 3);
    text(cx, cy, num2str(cell_label), 'Color', cell_color, 'FontSize', 14, 'FontWeight', 'bold')
end
xlabel('Microns')
ylabel('Microns')


figure();
subplot(1, 2, 1);

spikes = getSpikeTimes(exp_id);
pattern_id = filterHoloPatterns(s.repetitions, 'Allowed_N_Spots', 1, 'Optional_Spots', spot_id);
plotCellsRaster(spikes(cell_ids), s.repetitions.rep_begins{pattern_id}, s.repetitions.durations(pattern_id), getMeaRate(exp_id), ...
    'Raster_Colors', cell_colors, ...
    'Pre_Stim_DT', 0.2, ...
    'Post_Stim_DT', 0.2);

axis off
hold on
plot([-0.2, -0.1], [0, 0], 'k', 'LineWidth', 1.5);
text(-0.15, 0, '100ms','HorizontalAlignment','center', 'VerticalAlignment', 'bottom')
title("");


subplot(1, 2, 2);

psths = getHolographyPSTHs(exp_id);
multi_psth = psths(holo_section_id);
plotStimPSTH(squeeze(multi_psth.psth.responses(pattern_id, cell_ids, :)), multi_psth.psth.t_bin, ...
                'PSTH_Colors', cell_colors, ...
                'Stim_Onset_Seconds', multi_psth.psth.t_spacing, ...
                'Stim_Offset_Seconds', -multi_psth.psth.t_spacing);

axis off
xlim([0.3, 1.2]);
hold on
plot([0.35, 0.45], [0, 0], 'k', 'LineWidth', 1.5);
text( 0.4, 0, '100ms','HorizontalAlignment','center', 'VerticalAlignment', 'bottom')
title("");
