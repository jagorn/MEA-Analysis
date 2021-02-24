clear
close all

dh_session = 3;
mea_rate = 20000;
evt_dt = 0.5 * mea_rate;

n_min_activations = 2;
n_min_patterns = 10;
n_max_patterns = 30;

% Paths
frames_file = ['/home/fran_tr/Data/20200131_dh/processed/DH/DHFrames_' num2str(dh_session) '.mat'];
mea_map_file = '/home/fran_tr/Projects/MEA-Analysis/Rig/PositionsMEA.mat';
dh_times_file = '/home/fran_tr/Data/20200131_dh/processed/DH/DHTimes.mat';
spikes_file = '/home/fran_tr/Data/20200131_dh/sorted/CONVERTED/CONVERTED.mua.hdf5';

% Load Event Markers
load(dh_times_file, 'dhTimes');
dh_times = dhTimes{dh_session}.evtTimes_begin;
n_dh_times = numel(dh_times);

% Load Event Order
load(frames_file, 'OrderFrames');
dh_order = OrderFrames(1:n_dh_times);

% Load Mea Map
load(mea_map_file, 'Positions');
mea_map = double(Positions);

% Read Spikes
spikes = readSpikeTimes(spikes_file, true);


z_scores =  computeActivations(spikes, dh_times, evt_dt, dh_order, mea_rate, ...
                               'MEA_Map', mea_map, ...
                               'Plot_Psths', true, ...
                               'Plot_Activation', true);
                           
chosen_patterns = selectPatterns(z_scores, ...
                                 'N_Min_Activations', n_min_activations, ...
                                 'N_Min_Patterns', n_min_patterns, ...
                                 'N_Max_Patterns', n_max_patterns);
                           
                           