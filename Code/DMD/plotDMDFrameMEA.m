function plotDMDFrameMEA(exp_id, dh_section, stim_id, stim_version, frame_id, polarity)

% EXAMPLES OF PARAMETERS
% exp_id = '20210517_a2';
% dh_section = 4;
% stim_id = 'discdelay';
% stim_version = 'spots_fast_white_disc_delay';
% frame_id = 2;
% polarity = true;



h_ref = getHoloSection(exp_id, dh_section).h_ref;

% % Load Homographies
HDMD_2_Camera = getHomography('DMD', 'CAMERA');
HCamera_2_MEA = getHomography(h_ref, 'MEA', exp_id);
h = HCamera_2_MEA * HDMD_2_Camera;


plotDMDFrame(stim_id, stim_version, frame_id, 'Homography', h, 'Polarity', polarity)