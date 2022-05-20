function plotVisualHoloCard(exp_id, cell_id, holo_section_id, visual_section_id, varargin)



% Parse Input
p = inputParser;
addRequired(p, 'exp_id');
addRequired(p, 'cell_id');
addRequired(p, 'holo_section_id');
addRequired(p, 'visual_section_id');
addParameter(p, 'Holo_Pattern_Id', 1);
addParameter(p, 'Visual_Pattern_Id', 1);
addParameter(p, 'Holo_Win', [0 0.5]);
addParameter(p, 'Visual_Win', [0 0.5]);

parse(p, exp_id, cell_id, holo_section_id, visual_section_id, varargin{:});

holo_pattern_id = p.Results.Holo_Pattern_Id;
visual_pattern_id = p.Results.Visual_Pattern_Id;
holo_win = p.Results.Holo_Win;
visual_win = p.Results.Visual_Win;


% Sections
s_visual = getSection(exp_id, visual_section_id);
s_holo = getHoloSection(exp_id, holo_section_id);

% Spikes and Repetitions
all_spikes = getSpikeTimes(exp_id);
spikes = all_spikes{cell_id};
mea_rate =  getMeaRate(exp_id);

visual_reps = s_visual.repetitions.rep_begins{visual_pattern_id} - visual_win(1)* mea_rate;
holo_reps = s_holo.repetitions.rep_begins{holo_pattern_id} - holo_win(1)* mea_rate;
mixed_reps = {visual_reps, holo_reps};
mixed_duration_dt = (max(visual_win(2), holo_win(2)) - min(visual_win(1), holo_win(1)));
mixed_duration = mixed_duration_dt * mea_rate;
mixed_colors = [0.8, 0.2, 0.2; 0, 0, 0];

% Spots
h_camera_ref = s_holo.h_ref;
spot_idx = logical(s_holo.repetitions.patterns(holo_pattern_id, :));
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

% Add visual stim
c = getDMDStimShape(s_holo.stimulus);
c.Vertices = transformPointsV(HStim_2_MEA, c.Vertices);
[xc, yc] = boundary(c);
fill(xc, yc, 'w', 'FaceAlpha', 0.5);

% Receptive Fields
rf = rfs(cell_id);
rf.Vertices = transformPointsV(HChecker_2_MEA, rf.Vertices);
[x, y] = boundary(rf);
[cx, cy] = centroid(rf);
fill(x, y, 'r', 'FaceAlpha', 0.5);
text(cx, cy, 'RGC', 'Color', 'k', 'FontSize', 14, 'FontWeight', 'bold', 'VerticalAlignment', 'middle', 'HorizontalAlignment', 'center')

% Add Spot
scatter(spot_positions(:, 1), spot_positions(:, 2), 50, 'yellow', 'Filled');

xlabel('Microns')
ylabel('Microns')

ss = get(0,'screensize');
width = ss(1, 3);
height = ss(1, 4);
set(gcf,'Position', [0, height-400, width/3, 400]);


t_spacing = 0.2;
t_bin = 0.05;
n_bins = ceil((mixed_duration_dt + 2*t_spacing)/t_bin);
[ypsth_visual, ~, ~] = doPSTH(all_spikes, visual_reps - t_spacing*mea_rate, t_bin*mea_rate, n_bins, mea_rate, cell_id);
[ypsth_holo, ~, ~] = doPSTH(all_spikes, holo_reps - t_spacing*mea_rate, t_bin*mea_rate, n_bins, mea_rate, cell_id);
mixed_psths = [ypsth_visual, ypsth_holo]';

figure();
subplot(1, 2, 1);
plotStimRaster(spikes, mixed_reps, mixed_duration, mea_rate, ...
    'Labels', ["Disc", "Disc+Holo"], ...
    'Raster_Colors', mixed_colors, ...
    'Pre_Stim_DT', t_spacing, ...
    'Post_Stim_DT', t_spacing, ...
    'Edges_Onsets', [visual_win(1), holo_win(1)], ...
    'Edges_Offsets', [visual_win(2), holo_win(2)], ...
    'Edges_Colors', mixed_colors);


subplot(1, 2, 2);
if max(mixed_psths(:)') < 50
    max_psth = 50;
elseif max(mixed_psths(:)') < 100
    max_psth = 100;
else
    max_psth = 150;
end
plotStimPSTH(mixed_psths, t_bin, ...
                'Labels', ["Disc", "Disc+Holo"], ...
                'PSTH_max', max_psth, ...
                'PSTH_Colors', mixed_colors, ...
                'Stim_Onset_Seconds', t_spacing, ...
                'Stim_Offset_Seconds', -t_spacing, ...
                'Edges_Onsets', [visual_win(1), holo_win(1)] + t_spacing, ...
                'Edges_Offsets', [visual_win(2), holo_win(2)] + t_spacing, ...
                'Edges_Colors', mixed_colors);


set(gcf,'Position',[width*2/3, height-400, width/2, 400]);
