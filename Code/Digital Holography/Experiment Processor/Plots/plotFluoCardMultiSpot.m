function plotFluoCardMultiSpot(exp_id, holo_section_id, cell_id, spot_ids, varargin)


% Parse Input
p = inputParser;
addRequired(p, 'exp_id');
addRequired(p, 'holo_section_id');
addRequired(p, 'cell_ids');
addRequired(p, 'spot_ids');
addParameter(p, 'Spots_Color', []);

parse(p, exp_id, holo_section_id, cell_id, spot_ids, varargin{:});
spots_colors = p.Results.Spots_Color;

s = getHoloSection(exp_id, holo_section_id);
spot_position = s.positions.mea(spot_ids, :);
h_camera_ref = s.h_ref;
image_file = s.image;
image = imread(image_file);

[temporal, spatial, rfs, valid] = getSTAsComponents(exp_id);
if ~ismember(cell_id, valid)
    warning(strcat('Cell #', num2str(cell_id), ' does not have a valid STA'));
end

if isempty(spots_colors)
    hues = linspace(1/3, 1, numel(spot_ids));
    sat = 0.5 * ones(1, numel(spot_ids));
    val = 1.0 * ones(1, numel(spot_ids));
    spots_colors = hsv2rgb([hues; sat; val]');
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

pattern_ids = zeros(1, numel(spot_ids));
for i_spot = 1:numel(spot_ids)
    pattern_ids(i_spot) = filterHoloPatterns(s.repetitions, 'Allowed_N_Spots', 1, 'Optional_Spots', spot_ids(i_spot));
    scatter(spot_position(i_spot, 1), spot_position(i_spot, 2), 50, spots_colors(i_spot, :), 'Filled');
    text(spot_position(i_spot, 1), spot_position(i_spot, 2), strcat(num2str(i_spot), "  "), 'Color', spots_colors(i_spot, :), 'FontSize', 14, 'FontWeight', 'bold', 'HorizontalAlignment', 'right')
end

% Receptive Fields
rf = rfs(cell_id);
rf.Vertices = transformPointsV(HChecker_2_MEA, rf.Vertices);
[x, y] = boundary(rf);
plot(x, y, 'Color', 'r', 'LineWidth', 3);
    
xlabel('Microns')
ylabel('Microns')


figure();
subplot(1, 2, 1);

spikes = getSpikeTimes(exp_id);
plotStimRaster(spikes{cell_id}, s.repetitions.rep_begins(pattern_ids), median(s.repetitions.durations(pattern_ids)), getMeaRate(exp_id), ...
    'Raster_Colors', spots_colors, ...
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
plotStimPSTH(squeeze(multi_psth.psth.responses(pattern_ids, cell_id, :)), multi_psth.psth.t_bin, ...
                'PSTH_Colors', spots_colors, ...
                'Stim_Onset_Seconds', multi_psth.psth.t_spacing, ...
                'Stim_Offset_Seconds', -multi_psth.psth.t_spacing);

axis off
xlim([0.3, 1.2]);
hold on
plot([0.35, 0.45], [0, 0], 'k', 'LineWidth', 1.5);
text( 0.4, 0, '100ms','HorizontalAlignment','center', 'VerticalAlignment', 'bottom')
title("");
