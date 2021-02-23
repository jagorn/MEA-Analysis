clear

% Params
exp_id = '20200109_a2';
load_residuals = true;

dh_sessions = ["DH", "DH_DMD", "DH_BLOCK", "DH_DMD_BLOCK"];
dh_types = ["single", "test", "multi", "zero"];
dh_sessions_to_mask = [7];

dead_electrodes = [];
stim_electrodes = [127 128 255 256];

mea_rate = 20000;   % Hz
stim_duration = 0.5*mea_rate;
time_spacing = 0.2*mea_rate;
encoding = 'uint16';

% Inputs
raw_file = [dataPath(), '/', exp_id, '/sorted/CONVERTED.raw'];
mea_file = [dataPath() '/' exp_id '/PositionsMEA'];
dh_times_file = [dataPath() '/' exp_id '/processed/DH/DHTimes.mat'];

% Outputs
residuals_file_suffix = '_residuals.mat';
residuals_folder = [dataPath(), '/', exp_id, '/processed/DH/artifacts'];
dead_times_file = [dataPath(), '/', exp_id, '/sorted/dead_times_patterns.txt'];

% Load
changeDataset(exp_id);
load(dh_times_file, 'dhTimes')
load(mea_file, 'Positions')
mea_map = double(Positions);

% Compute Artifact Residuals
dead_times_artifacts = [];
for session_id = dh_sessions
    dh_struct = load(getDatasetMat, session_id);
    
    for type_id = dh_types
        dh_patterns = dh_struct.(session_id).repetitions.(type_id);
        
        for i_pattern = 1:numel(dh_patterns)
            dh_triggers = dh_patterns{i_pattern};
            
           % Load the dead times and use them
            residuals_file = [char(session_id) '_' char(type_id) '_' num2str(i_pattern) residuals_file_suffix];
            if exist([residuals_folder '/' residuals_file], 'file') && load_residuals
                load([residuals_folder '/' residuals_file], 'dead_init', 'dead_end');

             % Or compute the them if it had not been done before           
            else     
                % compute residuals and dead_time intervals
                elec_residuals = computeElectrodeResiduals(raw_file, dh_triggers, stim_duration, time_spacing, mea_map, encoding);
                mea_residual = computeMEAResidual([stim_electrodes, dead_electrodes], elec_residuals);
                [dead_init, dead_end] = computeDeadIntervals(mea_residual, time_spacing);
                
                % save
                save([tmpPath '/' residuals_file], 'dead_init', 'dead_end', 'time_spacing', 'stim_duration', 'mea_rate');
                save([tmpPath '/' residuals_file], 'elec_residuals', 'mea_residual', '-append');
                movefile([tmpPath '/' residuals_file], residuals_folder);
            end                
            dead_times_artifacts = [dead_times_artifacts; computeDeadTimes(dh_triggers, dead_init, dead_end)];
        end
    end
end

% Compute Dead Times on dh session to mask completely:
dead_times_covered = zeros(0, 2);
n_dt = 0;
for i_dh = 1:numel(dh_sessions_to_mask)
    for i_t = 1:numel(dhTimes{dh_sessions_to_mask(i_dh)}.evtTimes_begin)
        dead_init = dhTimes{dh_sessions_to_mask(i_dh)}.evtTimes_begin(i_t) - time_spacing;
        dead_end = dhTimes{dh_sessions_to_mask(i_dh)}.evtTimes_end(i_t) + time_spacing;
        n_dt = n_dt +1;
        dead_times_covered(n_dt, :) =  [dead_init dead_end];
    end
end

% Put together and sort all dead times
dead_times = [dead_times_artifacts; dead_times_covered];
[~, order] = sort(dead_times(:,1));
dead_times = dead_times(order, :);

writematrix(dead_times, dead_times_file,'Delimiter','tab')