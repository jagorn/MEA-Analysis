clear

bin_dt = 0.05;
k_zscore = 5;
min_firing_rate = 5;

control_window = [-0.250, -0.050];
response_window = [+0.050, +0.450];
spacing = 0.300;


dat_path = '/home/fran_tr/Data/dhgui_test/raws';
dat_prefix = 'checker_sppa0001';
frames_file = '/home/fran_tr/Data/20200131_dh/processed/DH/DHFrames_2.mat';

mu_channels = 1:30; %[1:126, 129:254];
dh_channel = 127;  %128;
dh_dt = 0.5;

spikes = readSpikeTimesSecondsDAT(dat_path, dat_prefix, mu_channels);
dh_times = readSpikeTimesSecondsDAT(dat_path, dat_prefix, dh_channel);

load(frames_file)
order_frames = OrderFrames(1:numel(dh_times));
frame_ids = uniques(order_frames);

n_bins = round((dh_dt + spacing*2) /bin_dt);
repetitions = dh_times - spacing;

ctrl = control_window + spacing;
rsp = response_window + spacing;

for frame_id = frame_ids 
    frame_times = dh_times(order_frames == frame_id);
    [psth, x_psth] = doPSTH(spikes, frame_times, bin_dt, n_bins,  1, mu_channels);
    z = EstimateZscore(psth, x_psth, ctrl, rsp, k_zscore, min_firing_rate);
end

