clear

% Params
exp_id = '20200131_dh';
mea_rate = 20000;   % Hz

dead_electrodes = [];
stim_electrodes = [127 128 255 256];
 
% Folders
mea_file = [dataPath() '/' exp_id '/PositionsMEA'];
residual_file = [dataPath(), '/', exp_id, '/processed/DH/artifacts/dh_residuals.mat'];

% Load
load(mea_file, 'Positions')
mea_map = double(Positions);

load(residual_file, 'dead_init', 'dead_end', 'elec_residuals', 'mea_residual', 'time_spacing', 'stim_duration')        

plotMEA()
plotDataMEA(elec_residuals, mea_map, 'blue', dead_electrodes)
title(residual_file, 'Interpreter', 'None')
plotDeadIntervals(dead_init, dead_end, mea_residual, time_spacing, stim_duration, mea_rate);
