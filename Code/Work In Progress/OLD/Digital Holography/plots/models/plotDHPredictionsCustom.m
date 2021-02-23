% function plotDHPredictionsCustom(i_cell, model_label)

i_cell = 15;
spots = [4, 22];
model_label = 'LNP';

figure()
fullScreen()
n_rasters = 4;

plotDHRaster(i_cell, 'DHMulti', 'multi', ...
    'Is_Subfigure', true, ...
    'Columns_Indices', 1, ...
    'Spots_Idx', spots, ...
    'N_Columns', n_rasters);

plotDHRaster(i_cell, 'DHMulti', 'single', ...
    'Is_Subfigure', true, ...
    'Columns_Indices', 2, ...
    'N_Columns', n_rasters);

plotDHRaster(i_cell, 'DHMulti', 'test', ...
    'Is_Subfigure', true, ...
    'Columns_Indices', 3, ...
    'N_Columns', n_rasters);


subplot(1, n_rasters, n_rasters);
plotDHPredictionHistos(i_cell, 'DHMulti', model_label)

%     'Dead_Times', true, ...