clear
close all
clc

% load 
load('/home/fran_tr/Projects/MEA-Analysis/Articles/Typing/_data/all_data.mat');

% % Params
% params.min_SNR_type = 0.58;
% params.min_size_type = 5;
% params.min_size_mosaic = 5;
% params.rf_unit_size = 50;  % microns
% params.rf_size = [38, 51] * params.rf_unit_size;
% params.roi_size = [500, 500];
% params.n_simulations = 100;
% 
% 
% % parse
% types = getTypes(classesTableNotPruned, params.min_SNR_type, params.min_size_type);
% mosaics = getTypeMosaics(cellsTable, types, params.min_size_mosaic, duplicate_cells);
% mosaics = annotatePreviousValidation(mosaics, mosaics_validated_old);
% rfs_microns = rfsToMicrons(rfs, params.rf_unit_size, params.rf_size, params.roi_size);
mosaic_idx =  27; % 1:numel(mosaics);

% run
regularity = checkMosaicRegularity(mosaics, rfs_microns, params.roi_size, 'Add_To_Regularities', regularity, 'Mosaic_Idx', mosaic_idx);

% save
% save('/home/fran_tr/Projects/MEA-Analysis/Articles/Typing/_data/all_data.mat', '-append');

% benchmark
% generateBenchmarkMosaics(cellsTable, mosaics, rfs_microns, params.roi_size, params.n_simulations, mosaic_idx, true);
% mosaics = computeBenchmarkRegularity(mosaics, regularity);
% save('/home/fran_tr/Projects/MEA-Analysis/Articles/Typing/_data/all_data.mat', '-append');
% disp("done.");
 
% plot
% plotMosaics(rfs_microns, mosaics(mosaic_idx), params.roi_size);
% showRegularityMosaics(rfs_microns, mosaics(mosaic_examples), regularity(mosaic_idx), params.roi_size);
% showMosaicBenchmarks(rfs_microns, mosaics(mosaic_idx), regularity(mosaic_idx), params.roi_size);

% save valid mosaics
% valid_mosaics_idx = ([mosaics.nnri_test] < 0.15) & ([mosaics.er_test] < 0.15);
% valid_mosaics_idx_old = [mosaics.ks_validated];
% if any(valid_mosaics_idx_old & ~valid_mosaics_idx)
%     find(valid_mosaics_idx_old & ~valid_mosaics_idx)
%     error("some mosaics have not been reconfirmed");
% end
% valid_mosaics = mosaics(valid_mosaics_idx);
% save('/home/fran_tr/Projects/MEA-Analysis/Articles/Typing/_data/all_data.mat', 'valid_mosaics', '-append');
