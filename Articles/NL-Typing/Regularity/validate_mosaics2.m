clear
close all
clc

% load 
load('/home/fran_tr/Projects/MEA-Analysis/Articles/Typing/_data/all_dataRF.mat');
% duplicate_cellsRF = duplicate_cells;
% duplicate_cellsRF([159 27 121 154 74 86 264 354 297]) = true;

% parse
% mosaicsRF = convertStaTable(mosaics_all_oldRF, params.min_size_mosaic, duplicate_cellsRF, temporalSTAs);
% mosaicsRF = annotatePreviousValidation(mosaicsRF, mosaics_validated_oldRF);
% mosaic_idxRF = 1:numel(mosaicsRF);

% run
% regularityRF = checkMosaicRegularity(mosaicsRF, rfs_microns, params.roi_size, 'Add_To_Regularities', regularityRF, 'Mosaic_Idx', mosaic_idxRF);

% save
% save('/home/fran_tr/Projects/MEA-Analysis/Articles/Typing/_data/all_dataRF.mat', 'mosaicsRF', 'regularityRF', 'duplicate_cellsRF', '-append');

% benchmark
% generateBenchmarkMosaics(cellsTable, mosaicsRF, rfs_microns, params.roi_size, params.n_simulations, mosaic_idxRF);
% mosaicsRF = computeBenchmarkRegularity(mosaicsRF, regularityRF);

% save('/home/fran_tr/Projects/MEA-Analysis/Articles/Typing/_data/all_dataRF.mat', 'mosaicsRF', '-append');
% disp("done.");

% plot
% plotMosaics(rfs_microns, mosaicsRF(mosaic_idxRF), params.roi_size);
% showRegularityMosaics(rfs_microns, mosaicsRF(mosaic_idxRF), regularity(mosaic_idxRF), params.roi_size);
showMosaicBenchmarks(rfs_microns, mosaicsRF(mosaic_idxRF), regularityRF(mosaic_idxRF), params.roi_size);


