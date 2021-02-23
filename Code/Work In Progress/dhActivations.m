% clear
% close all

n_dh_times = 514;
bin_dt = 0.05;
k_zscore = 5;
min_firing_rate = 5;

control_window = [-0.250, -0.050];
response_window = [+0.050, +0.450];
spacing = 0.250;


dat_path = '/home/fran_tr/Data/20200131_dh/processed/DH/OnlineMUA';
dat_prefix = 'mua_sppa0001';
trig_prefix = 'trigs_sppa0002';

frames_file = '/home/fran_tr/Data/20200131_dh/processed/DH/DHFrames_2.mat';
load('/home/fran_tr/Projects/MEA-Analysis/Rig/PositionsMEA.mat')


mu_channels = [1:126, 129:254];
dh_channel = 128;
dh_dt = 0.5;

spikes = readSpikeTimesSecondsDAT(dat_path, dat_prefix, mu_channels);
dh_times = readSpikeTimesSecondsDAT(dat_path, trig_prefix, dh_channel);
dh_times = dh_times{1};

load(frames_file)
order_frames = OrderFrames(1:n_dh_times);
dh_times = dh_times(1:n_dh_times);

frame_ids = unique(order_frames);

n_elecs = numel(mu_channels);
n_patterns = numel(frame_ids);

n_bins = round((dh_dt + spacing*2) /bin_dt);
repetitions = dh_times - spacing;

ctrl = control_window + spacing;
rsp = response_window + spacing;

zs_elec2pattern = zeros(n_elecs, n_patterns);
psths = zeros(n_elecs, n_patterns, n_bins);

for i_pattern = 1:n_patterns
    frame_id = frame_ids(i_pattern);
    frame_times = dh_times(order_frames == frame_id);
    [psth, x_psth] = doPSTH(spikes, frame_times, bin_dt, n_bins,  1, 1:n_elecs);
    
    psths(:, i_pattern, :) = psth;
    zs_elec2pattern(:, i_pattern) = estimateZscore(psth, x_psth, ctrl, rsp, k_zscore, min_firing_rate);
end

plotMEA();
plotGridMEA();
plotPsthMEA(squeeze(psths(:, 2, :)), spacing, (dh_dt + spacing*2), double(Positions(mu_channels, :)))