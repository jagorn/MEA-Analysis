

spikes = readSpikeTimesSecondsDAT(dat_path, dat_prefix, mu_channels);
dh_times = readSpikeTimesSecondsDAT(dat_path, trig_prefix, dh_channel);
dh_times = dh_times{1};

load(frames_file)
order_frames = OrderFrames(1:n_dh_times);
dh_times = dh_times(1:n_dh_times);

frame_ids = unique(order_frames);

n_elecs = numel(mu_channels);
n_patterns = numel(frame_ids);

dh_window = (dh_dt + spacing*2);
n_bins = round(dh_window /bin_dt);

ctrl = control_window + spacing;
rsp = response_window + spacing;

zs_elec2pattern = zeros(n_elecs, n_patterns);
psths = zeros(n_elecs, n_patterns, n_bins);

mea_map = double(Positions(mu_channels, :));


for i_pattern = 1:n_patterns
    frame_id = frame_ids(i_pattern);
    frame_times = dh_times(order_frames == frame_id);
    plotRasterMEA(spikes, frame_times, dh_dt, spacing, 1, mea_map);
    waitforbuttonpress();
    close();
    
    repetitions = frame_times - spacing;
    [psth, x_psth] = doPSTH(spikes, repetitions, bin_dt, n_bins,  1, 1:n_elecs);
    psths(:, i_pattern, :) = psth;
    zs_elec2pattern(:, i_pattern) = estimateZscore(psth, x_psth, ctrl, rsp, k_zscore, min_firing_rate);
end



for i = 1:n_patterns
    plotMEA();
    plotGridMEA();
    plotPsthMEA(squeeze(psths(:, 2, :)), spacing, dh_window, mea_map)
    waitforbuttonpress();
    close();
end