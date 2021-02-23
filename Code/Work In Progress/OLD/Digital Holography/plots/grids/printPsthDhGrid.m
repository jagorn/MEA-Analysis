% Params
dh_session_psth = 'DHGridBlock20';
dh_session_model = 'DHGridBlock';
model_label = 'LNP07';
cells = 1:151;
do_print = true;

grid_scale = 0.04;

% Paths
exp_id = getExpId();
rasters_folder = [dataPath() '/' exp_id '/processed/DH/Plots/Rasters'];

% Load
s = load(getDatasetMat, dh_session_psth);
single_frames = boolean(s.(dh_session_psth).stimuli.single);
single_psths = s.(dh_session_psth).responses.single.firingRates;

offset = -s.(dh_session_psth).params.t_offset;
period = s.(dh_session_psth).params.period;

[n_patterns, n_spots] = size(single_frames);
coords_MEA = getDHSpotsCoordsMEA(dh_session_psth);

% Build DH positions in grid
dh_positions = zeros(n_patterns, 2);
for i_pattern = 1:n_patterns
        spot = find(single_frames(i_pattern, :));
        dh_positions(i_pattern, 1) = coords_MEA(spot, 1)*grid_scale;
        dh_positions(i_pattern, 2) = coords_MEA(spot, 2)*grid_scale;
end
    
max_psth = max(single_psths(:));
for i_cell = cells            

    figure()
    subplot(2, 3, [1, 2, 4, 5])
    plotPsthDhGrid(single_psths(i_cell, :, :), max_psth, dh_positions, offset, period)
    
    title_1 = strcat("Cell #", string(i_cell), " DH GRID ", dh_session_psth);
    title(title_1, 'Interpreter', 'None')

    subplot(2, 3, [3, 6])
    plotDHWeights(i_cell, dh_session_model, model_label)
    
    fullScreen()
    
    if do_print
        raster_name = [num2str(dh_session_psth) '_psth_' num2str(i_cell)];
        saveas(gcf, [tmpPath '/' raster_name],'jpg');
        movefile([tmpPath '/' raster_name '.jpg'], rasters_folder);
        close;
    end
end