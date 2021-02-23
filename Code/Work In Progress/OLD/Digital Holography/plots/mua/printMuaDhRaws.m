% Params
exp_id = '20200109_a2';
dh_session = 'DH_DMD_BLOCK';
pattern_type = 'single';

mea_rate = 20000;
spacing = 0.25 * mea_rate;
chunk_size = 0.5 * mea_rate + spacing*2;
dead_electrodes = [];
elec_radius = 30;

raw_filt = [dataPath '/' exp_id '/sorted/CONVERTED.raw'];
% raw_unfilt = [dataPath '/' exp_id '/sorted/CONVERTED_NO_FILT.raw'];

repetitions_file = [dataPath '/' exp_id '/processed/DH/DHRepetitions' dh_session '.mat'];
coords_file = [dataPath, '/' exp_id '/processed/DH/DHCoords' dh_session '.mat'];
rasters_folder = [dataPath '/' exp_id '/processed/DH/Plots/'];

mea_file = 'PositionsMEA';
load(mea_file, 'Positions')
load(coords_file, 'PatternCoords_MEA')

evt_begin_label = [pattern_type '_begin_time'];
frames_label = [pattern_type '_frames'];
s = load(repetitions_file, evt_begin_label, frames_label);

n_patterns = numel(s.(evt_begin_label));
x = PatternCoords_MEA(:, 1)/elec_radius;
y = PatternCoords_MEA(:, 2)/elec_radius;

for i_pattern = 1:n_patterns
    
    spot = find(s.(frames_label)(i_pattern, :));
    t = s.(evt_begin_label){i_pattern}(1); % always hosw just the 1st rep
    
    plotMEA();
    plotGridMEA()
%     plotFileDataMEA(raw_unfilt, t - spacing, chunk_size, 'blue', dead_electrodes);
    plotFileDataMEA(raw_filt, t - spacing, chunk_size, 'cyan', dead_electrodes);
    
    scatter(x, y, 'g');
    scatter(x(spot), y(spot), 'g', 'Filled');
    
    raster_name = [dh_session '_' pattern_type '_mua_raw#' num2str(i_pattern)];
    title(raster_name, 'Interpreter', 'None')
    
%     export_fig([tmpPath '/' raster_name '.svg'])
%     saveas(gcf, [tmpPath '/' raster_name],'svg');
%     movefile([tmpPath '/' raster_name '.svg'], rasters_folder);
    pause();
    close;
end



