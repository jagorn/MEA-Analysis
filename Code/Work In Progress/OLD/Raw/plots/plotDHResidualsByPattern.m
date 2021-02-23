clear

% Params
exp_id = '20200109_a2';
mea_rate = 20000;   % Hz
stim_duration = 0.5*mea_rate;
l_elec = 30;

dh_sessions = ["DH", "DMD", "DH_DMD", "DH_Block", "DMD_Block", "DH_DMD_Block"];
dh_types = ["single", "test", "multi", "zero"];

dead_electrodes = [];
stim_electrodes = [127 128 255 256];
 
% Folders
mea_file = [dataPath() '/' exp_id '/PositionsMEA'];
residual_folder = [dataPath(), '/', exp_id, '/processed/DH/artifacts'];
residual_file_suffix = '_residuals.mat';

% Load
load(mea_file, 'Positions')
mea_map = double(Positions);

changeDataset(exp_id)
elec_residuals_tot = 0;

for session_id = dh_sessions 
    
    dh_struct = load(getDatasetMat, session_id);
    
    for type_id = dh_types        
        
        dh_patterns = dh_struct.(session_id).repetitions.(type_id);
        for i_pattern = 1:numel(dh_patterns)            
            residual_file = [char(session_id) '_' char(type_id) '_' num2str(i_pattern) residual_file_suffix];
            load([residual_folder '/' residual_file], 'elec_residuals', 'time_spacing', 'stim_duration')   
            elec_residuals_tot = max(elec_residuals_tot, elec_residuals);
            
            plotMEA()
            plotDataMEA(elec_residuals, mea_map, 'blue', dead_electrodes)
            title([session_id ' ' type_id], 'Interpreter', 'None');
            
            pattern = logical(dh_struct.(session_id).stimuli.(type_id)(i_pattern, :));
            spots = dh_struct.(session_id).spots.coords_mea(pattern, :) / l_elec;
            scatter(spots(:, 1), spots(:, 2), 50, 'r', 'filled');

            waitforbuttonpress;
            close;
        end
    end
end

plotMEA()
plotDataMEA(elec_residuals_tot, mea_map, 'blue', dead_electrodes)
title(residual_file, 'Interpreter', 'None')

mea_residual = computeMEAResidual([stim_electrodes, dead_electrodes], elec_residuals_tot);
[dead_init, dead_end] = computeDeadIntervals(mea_residual, time_spacing);
plotDeadIntervals(dead_init, dead_end, mea_residual, time_spacing, stim_duration, mea_rate);
