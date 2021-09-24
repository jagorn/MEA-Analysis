clear
close all

cd('/home/fran_tr/Data/20210802_rd1_reachr2/processed');
mea_rate = 20000;
accepted_tag = 3;
evt_session = 1;
n_cells_panel = 20;
dt_euler = 25;
bin_dt = 0.05;

load('SpikeTimes.mat');
load('Euler_Triggers.mat', 'repetitions')
load('Tags.mat');

reps = repetitions{evt_session};
good_tags = find(tags >= accepted_tag);
good_spikes = spikes(good_tags);
n_cells = numel(good_spikes);

bin_size = round(bin_dt*mea_rate);
n_bins = round(n_steps_stim / bin_size);
    
figure();
fullScreen();


n_steps_stim = round(dt_euler * mea_rate);
[psth, xpsth, mean_psth, firing_rates] = doPSTH(good_spikes, repetitions, bin_size, n_bins,  mea_rate, 1:numel(good_spikes));

    
plotCellsRaster(spikes, reps, n_steps_stim, mea_rate, ...
    'Point_Size', 3, ...
    'Pre_Stim_DT', 0, ...
    'Post_Stim_DT', 0, ...
    'Cells_Indices', good_tags(cell_idx));
