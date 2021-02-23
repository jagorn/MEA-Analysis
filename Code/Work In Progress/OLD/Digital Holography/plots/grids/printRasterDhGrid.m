% Params
dh_session1 = 'DHGridBlock';
dh_session2 = 'DHGridBlock';

model_label = 'LNP07';

mea_rate = 20000;
grid_scale = 0.04;

n_max_rep = 40;
evt_binsize = 0.5 * mea_rate;
evt_spacing = 0.5 * mea_rate;

% Paths
exp_id = getExpId();
rasters_folder = [dataPath() '/' exp_id '/processed/DH/Plots/Rasters'];

% Load
load(getDatasetMat, 'spikes');
s = load(getDatasetMat, dh_session1);
single_begin_time = s.(dh_session1).repetitions.single;
single_frames = boolean(s.(dh_session1).stimuli.single);
coords_MEA = getDHSpotsCoordsMEA(dh_session1);

% Build DH positions in grid
dh_positions = zeros(numel(single_begin_time), 2);
for i_pattern = 1:numel(single_begin_time)
        spot = find(single_frames(i_pattern, :));
        dh_positions(i_pattern, 1) = coords_MEA(spot, 1)*grid_scale;
        dh_positions(i_pattern, 2) = coords_MEA(spot, 2)*grid_scale;
end
    
for i_cell = 1:numel(spikes)            

    figure()
    subplot(2, 3, [1, 2, 4, 5])
    plotRasterCellDhGrid(spikes{i_cell}, single_begin_time, evt_binsize, evt_spacing, dh_positions, mea_rate, n_max_rep);
    
    title_1 = strcat("Cell #", string(i_cell), " DH GRID ", dh_session1);
    title(title_1, 'Interpreter', 'None')

    subplot(2, 3, 3)
    plotDHWeights(i_cell, dh_session1, model_label)

%     subplot(2, 3, 6)
%     plotDHWeights(i_cell, dh_session2, model_label)
    
    fullScreen()
    
    raster_name = ['dhgrid' num2str(dh_session1) '_raster_cell' num2str(i_cell)];
    saveas(gcf, [tmpPath '/' raster_name],'jpg');
    movefile([tmpPath '/' raster_name '.jpg'], rasters_folder);
    close;
end