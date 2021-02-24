clear
close all

mea_rate = 1;
evt_dt = 0.5 * mea_rate;
n_dh_times = 514;

n_min_activations = 2;
n_min_patterns = 10;
n_max_patterns = 30;

% Paths
frames_file = '/home/fran_tr/Data/20200131_dh/processed/DH/DHFrames_2.mat';
mea_map_file = '/home/fran_tr/Projects/MEA-Analysis/Rig/PositionsMEA.mat';
dat_path = '/home/fran_tr/Data/20200131_dh/processed/DH/OnlineMUA';
dat_prefix = 'mua_sppa0001';
mu_channels = [1:126, 129:254];
trig_prefix = 'trigs_sppa0002';
dh_channel = 128;


% Load Event Markers
dh_times = readSpikeTimesSecondsDAT(dat_path, trig_prefix, dh_channel);
dh_times = dh_times{1};
dh_times = dh_times(1:n_dh_times);

% Load Event Order
load(frames_file, 'OrderFrames');
dh_order = OrderFrames(1:n_dh_times);

% Load Mea Map
load(mea_map_file, 'Positions');
mea_map = double(Positions);

% Read Spikes
spikes = readSpikeTimesSecondsDAT(dat_path, dat_prefix, mu_channels);


z_scores =  computeActivations(spikes, dh_times, evt_dt, dh_order, mea_rate, ...
                               'MEA_Map', mea_map, ...
                               'Plot_Psths', true, ...
                               'Plot_Activation', true);
                           
chosen_patterns = selectPatterns(z_scores, ...
                                 'N_Min_Activations', n_min_activations, ...
                                 'N_Min_Patterns', n_min_patterns, ...
                                 'N_Max_Patterns', n_max_patterns);
                           
                           