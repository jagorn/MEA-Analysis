function plotHoloCardMultiSpot(exp_id, cell_id, holo_section_id, varargin)



% Parse Input
p = inputParser;
addRequired(p, 'exp_id');
addRequired(p, 'cell_id');
addRequired(p, 'holo_section_id');
addParameter(p, 'Holo_Pattern_Id_Multi', []);
addParameter(p, 'Holo_Pattern_Idx_Single', []);
addParameter(p, 'Holo_Win', [0 0.5]);

parse(p, exp_id, cell_id, holo_section_id, varargin{:});

holo_multi_pattern_id = p.Results.Holo_Pattern_Id_Multi;
holo_single_pattern_idx = p.Results.Holo_Pattern_Idx_Single;
holo_win = p.Results.Holo_Win;

if numel(holo_multi_pattern_id) ~= 1
    error('number of multi-spot patterns must be one');
end

if numel(holo_single_pattern_idx) ~= 2
    error('number of single-spot patterns must be two');
end

% Sections
s_holo = getHoloSection(exp_id, holo_section_id);

% Spikes and Repetitions
all_spikes = getSpikeTimes(exp_id);
spikes = all_spikes{cell_id};
mea_rate =  getMeaRate(exp_id);

holo_reps = s_holo.repetitions.rep_begins{holo_multi_pattern_id} - holo_win(1)* mea_rate;
holo_reps_single1 = s_holo.repetitions.rep_begins{holo_single_pattern_idx(1)} - holo_win(1)* mea_rate;
holo_reps_single2 = s_holo.repetitions.rep_begins{holo_single_pattern_idx(2)} - holo_win(1)* mea_rate;

mixed_reps = {holo_reps_single1, holo_reps_single2, holo_reps};
mixed_duration_dt = holo_win(2) - holo_win(1);
mixed_duration = mixed_duration_dt * mea_rate;
mixed_colors = [0.1, 0.6, 0.1; 0.2, 0.2, 0.8; 0, 0, 0];
labels = ["Holo1", "Holo2", "Holo1&2"];

% Spots
h_camera_ref = s_holo.h_ref;
spot_idx = logical(s_holo.repetitions.patterns(holo_multi_pattern_id, :));
spot_positions = s_holo.positions.mea(spot_idx, :);
image = imread(fullfile(getH_ImagesPath(),'camera_center_x10.jpg'));

% STA
[~, ~, rfs, valid] = getSTAsComponents(exp_id);
if ~ismember(cell_id, valid)
    warning(strcat('Cell #', num2str(cell_id), ' does not have a valid STA'));
end

% Load Homographies
HDMD_2_Camera = getHomography('DMD', 'CAMERA');
HCamera_2_MEA_Fix = getHomography('CAMERA_X10', 'MEA');
HChecker_2_DMD = getHomography('CHECKER20', 'DMD');
HCamera_2_MEA_Fluo = getHomography(h_camera_ref, 'MEA', exp_id);

% Compose Homographies
HChecker_2_MEA = HCamera_2_MEA_Fix * HDMD_2_Camera * HChecker_2_DMD;
HStim_2_MEA = HCamera_2_MEA_Fluo * HDMD_2_Camera;
[img_2mea, imgRef_2mea] = transformImage(HCamera_2_MEA_Fix, image);

% Plot
figure();
imshow(img_2mea, imgRef_2mea);
hold on

% Receptive Fields
rf = rfs(cell_id);
rf.Vertices = transformPointsV(HChecker_2_MEA, rf.Vertices);
[x, y] = boundary(rf);
[cx, cy] = centroid(rf);
fill(x, y, 'r', 'FaceAlpha', 0.5);
text(cx, cy, 'RGC', 'Color', 'k', 'FontSize', 14, 'FontWeight', 'bold', 'VerticalAlignment', 'middle', 'HorizontalAlignment', 'center')

% Add Spot
scatter(spot_positions(1, 1), spot_positions(1, 2), 50, mixed_colors(1, :), 'Filled');
scatter(spot_positions(2, 1), spot_positions(2, 2), 50, mixed_colors(2, :), 'Filled');

xlabel('Microns')
ylabel('Microns')

ss = get(0,'screensize');
width = ss(1, 3);
height = ss(1, 4);
set(gcf,'Position', [0, (height/2 -300), width/2, 600]);


t_spacing = 0.2;
t_bin = 0.05;
n_bins = ceil((mixed_duration_dt + 2*t_spacing)/t_bin);
[ypsth_holosingle1, ~, ~] = doPSTH(all_spikes, holo_reps_single1 - t_spacing*mea_rate, t_bin*mea_rate, n_bins, mea_rate, cell_id);
[ypsth_holosingle2, ~, ~] = doPSTH(all_spikes, holo_reps_single2 - t_spacing*mea_rate, t_bin*mea_rate, n_bins, mea_rate, cell_id);
[ypsth_holomulti, ~, ~] = doPSTH(all_spikes, holo_reps - t_spacing*mea_rate, t_bin*mea_rate, n_bins, mea_rate, cell_id);
mixed_psths = [ypsth_holosingle1, ypsth_holosingle2, ypsth_holomulti]';

figure();
subplot(1, 2, 1);
plotStimRaster(spikes, mixed_reps, mixed_duration, mea_rate, ...
    'Labels', labels, ...
    'Raster_Colors', mixed_colors, ...
    'Pre_Stim_DT', t_spacing, ...
    'Post_Stim_DT', t_spacing, ...
    'Edges_Onsets', holo_win(1), ...
    'Edges_Offsets', holo_win(2), ...
    'Edges_Colors', mixed_colors);


subplot(1, 2, 2);
if max(mixed_psths(:)') < 50
    max_psth = 50;
elseif max(mixed_psths(:)') < 100
    max_psth = 100;
else
    max_psth = 150;
end

overlay_psth = nan(size(mixed_psths));
overlay_psth(3, :) = ypsth_holosingle1 + ypsth_holosingle2;
plotStimPSTH(mixed_psths, t_bin, ...
                'Labels', labels, ...
                'PSTH_max', max_psth, ...
                'PSTH_Colors', mixed_colors, ...
                'Stim_Onset_Seconds', t_spacing, ...
                'Stim_Offset_Seconds', -t_spacing, ...
                'Edges_Onsets', holo_win(1) + t_spacing, ...
                'Edges_Offsets', holo_win(2) + t_spacing, ...
                'Edges_Colors', mixed_colors, ...
                'Overlays', overlay_psth);


set(gcf,'Position',[width/2, (height/2 -300), width/2, 600]);
