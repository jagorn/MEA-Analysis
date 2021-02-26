clear
close all

exp_id = '20200131_dh';
mua_name = 'CONVERTED';
dh_session = 2;


mea_rate = 20000;
evt_dt = 0.5 * mea_rate;

n_min_activations = 5;
n_min_patterns = 10;
n_max_patterns = 30;

% Paths
frames_file = fullfile(processedPath(exp_id), 'DH', strcat('DHFrames_', num2str(dh_session), '.mat'));
mea_map_file = fullfile(rigPath, 'PositionsMEA.mat');
dh_times_file = fullfile(processedPath(exp_id), 'DH', 'DHTimes.mat');
spikes_file = fullfile(sortedPath(exp_id), mua_name, strcat(mua_name, '.mua.hdf5'));

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


disp('analyzing dh activations...');
z_scores =  computeActivations(spikes, dh_times, evt_dt, dh_order, mea_rate, ...
                               'MEA_Map', mea_map, ...
                               'Plot_Psths', false, ...
                               'Plot_Activation', true);
                           
disp('optimizing dh spots...');
chosen_patterns = selectPatterns(z_scores, ...
                                 'N_Min_Activations', n_min_activations, ...
                                 'N_Min_Patterns', n_min_patterns, ...
                                 'N_Max_Patterns', n_max_patterns);
                           
 n_spots = numel(unique(dh_order));
 n_spots_selected = numel(chosen_patterns);
 fprintf('the selected spots are %i out of %i:\n', n_spots_selected, n_spots);
 for pattern = chosen_patterns
     fprintf('%i ', pattern)
 end
 fprintf('\n\n');
                           