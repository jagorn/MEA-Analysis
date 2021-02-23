% Params
exp_id = '20200109_a2';
dh_session = 'DMD';
pattern_type = 'single';

mea_rate = 20000;
mea_channels = [1:126, 129:254]; % excluded trigger electrodes
n_max_rep = 20;
evt_binsize = 0.5 * mea_rate;
evt_spacing = 0.5 * mea_rate;

elec_radius = 30;
offset = 0.5;

% Paths
exp_folder = [dataPath() '/' exp_id '/'];
processed_folder = [exp_folder 'processed/'];
dh_folder = [processed_folder 'DH/'];
rasters_folder = [processed_folder 'DH/Plots/'];

mea_file = [exp_folder 'PositionsMEA.mat'];
spikes_file = [processed_folder  'muaSpikeTimes.mat'];
repetitions_file = [dh_folder 'DHRepetitions' dh_session '.mat'];
coords_file = [dh_folder 'DHCoords' dh_session '.mat'];

% Load
load(mea_file, 'Positions');
load(spikes_file, 'SpikeTimes');
load(coords_file, 'PatternCoords_MEA');

evt_begin_label = [pattern_type '_begin_time'];
frames_label = [pattern_type '_frames'];
s = load(repetitions_file, evt_begin_label, frames_label);

mea_map = double(Positions);
x_spots = PatternCoords_MEA(:, 1)/elec_radius;
y_spots = PatternCoords_MEA(:, 2)/elec_radius;

for i_pattern = 1:numel( s.(evt_begin_label))
    
    spot = find(s.(frames_label)(i_pattern, :));
    
    plotMEA()
    plotGridMEA()
    fullScreen()
    
    plotRasterMEA(SpikeTimes, s.(evt_begin_label){i_pattern}, evt_binsize, evt_spacing, mea_channels, mea_map, mea_rate, n_max_rep);
    spot_plot = scatter(x_spots(spot), y_spots(spot), 100, 'r', 'Filled');
    spot_plot.MarkerFaceAlpha = 0.5;
    
    raster_name = [dh_session '_' pattern_type '_mua_raster#' num2str(i_pattern)];
    title(raster_name, 'Interpreter', 'None')
    saveas(gcf, [tmpPath '/' raster_name],'jpg');
    movefile([tmpPath '/' raster_name '.jpg'], rasters_folder);
    close;
end
