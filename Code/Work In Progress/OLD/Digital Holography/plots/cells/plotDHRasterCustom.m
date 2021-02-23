function plotDHRasterCustom(i_cell)

n_rasters = 3;

figure()
fullScreen()

plotDHRaster(i_cell, 'DHSingle', 'single', ...
    'Is_Subfigure', true, ...
    'Columns_Indices', 1, ...
    'Labels_Mode', 1, ...
    'Dead_Times', false, ...
    'N_Columns', n_rasters)

plotDHRaster(i_cell, 'DHMulti', 'single', ...
    'Is_Subfigure', true, ...
    'Columns_Indices', 2, ...
    'Labels_Mode', 1, ...
    'Dead_Times', false, ...
    'N_Columns', n_rasters)

plotDHRaster(i_cell, 'DHMulti', 'test', ...
    'Is_Subfigure', true, ...
    'Columns_Indices', 3, ...
    'Labels_Mode', 1, ...
    'Dead_Times', false, ...
    'N_Columns', n_rasters)
% 
% export_fig([plotsPath() '/' getDatasetId() '/' 'DHSingle_rasters_cell#' num2str(i_cell)], '-png')
% close

% plotDHRaster(i_cell, 'DHMulti20', 'single', ...
%     'Is_Subfigure', true, ...
%     'Columns_Indices', 3, ...
%     'Dead_Times', true, ...
%     'N_Columns', n_rasters)
% 
% plotDHRaster(i_cell, 'DHMulti20', 'test', ...
%     'Is_Subfigure', true, ...
%     'Columns_Indices', 4, ...
%     'Dead_Times', true, ...
%     'N_Columns', n_rasters)