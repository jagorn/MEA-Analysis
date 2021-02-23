close all
clear

% model = 'LNP';
% session_label = 'DHMulti';
% plotDHRasterCustom(i_cell)
load(getDatasetMat, 'cellsTable');
% s = load(getDatasetMat, session_label);
exp_id = getExpId();

% idx_cells = find(s.(session_label).activation > 0.6)';
idx_cells = 1:numel(cellsTable);
path = [dataPath '/' exp_id '/processed/DH'];

if ~exist([path '/Plots'], 'dir')
    mkdir([path '/Plots'])
end

for i_cell = idx_cells
    plotDHRasterCustom(i_cell)
    
%     plotCellCard(i_cell);
%     saveas(gcf, [tmpPath '/' session_label '_cell_full' num2str(i_cell)], 'jpg');
%     movefile([tmpPath '/' session_label '_cell_full' num2str(i_cell) '.jpg'], [path '/Plots'])
%     close;
    
%     plotDHWeights(i_cell, session_label, model);
%     saveas(gcf, [path '/Plots/' session_label num2str(i_cell) '_Weights'],'jpg');
%     close;

%     plotDHPredictions(i_cell, session_label, model);
%     saveas(gcf, [path '/Plots/' session_label num2str(i_cell) '_Predictions'],'jpg');
%     close;
%     
%     plotDHRasterSingleAndTest(i_cell, session_label);
%     saveas(gcf, [tmpPath '/' session_label '_raster_full'  num2str(i_cell)], 'jpg');
%     movefile([tmpPath '/' session_label '_raster_full'  num2str(i_cell) '.jpg'], [path '/Plots'])
%     close;
    
%     plotDHFiringRates(i_cell, 'DHSingle')
%     saveas(gcf, [tmpPath '/' session_label '_firing_rates_full'  num2str(i_cell)], 'jpg');
%     movefile([tmpPath '/' session_label '_firing_rates_full'  num2str(i_cell) '.jpg'], [path '/Plots'])
%     close;
    
%     plotDHRaster(i_cell, session_label, 'test');
%     saveas(gcf, [tmpPath '/' session_label num2str(i_cell) '_RastersTest'],'jpg');
%     movefile([tmpPath '/' session_label num2str(i_cell) '_RastersTest.jpg'], [path '/Plots'])
%     close;
%     
%     plotDHAccuracyCorr(i_cell, session_label, model);
%     saveas(gcf, [path '/Plots/' session_label num2str(i_cell) '_acc'],'jpg');
%     close;
 
end