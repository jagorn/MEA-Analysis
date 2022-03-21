function plotVisualStimMEA(~)
% TODO

% Parameters
exp_id = '20210517_a2';
stim_name = 'discdelay';
stim_version = 'spots_new_disc_delay';
stim_frame_id = 2;
img_id = 'mea_left';

% Load Disc
bin_file = getBinaryFile(stim_name, stim_version);
stim_frame = extractFrameBin(bin_file, stim_frame_id, true);
stim_frame = stim_frame - min(stim_frame(:));
stim_frame = stim_frame/max(stim_frame(:));

% Load Homographies
HDMD_2_Camera = getHomography('DMD', 'CAMERA');
HImage_2_MEA = getHomography(strcat('CAMERA_', img_id), 'MEA', exp_id);

% Compose Homographies
HDMD_2_MEA = HImage_2_MEA * HDMD_2_Camera;
    
% Transform Disc
[stim_frame_mea, ref_mea] = transformImage(HDMD_2_MEA, stim_frame);

% Add colors and opacity
stim_frame_mea_rgb = cat(3, stim_frame_mea, stim_frame_mea, stim_frame_mea);
m = imshow(stim_frame_mea_rgb, ref_mea);
set(m, 'AlphaData', 0.3);
hold on