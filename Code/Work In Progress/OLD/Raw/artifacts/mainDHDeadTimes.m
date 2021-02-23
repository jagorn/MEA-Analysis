clear

% Params
exp_id = '20200131_dh';
load_residuals = true;


dh_sessions_to_process = 1;
dh_sessions_to_mask = [2 3 4];

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
residuals_file = 'dh_residuals.mat';
residuals_folder = [dataPath(), '/', exp_id, '/processed/DH/artifacts'];
dead_times_file = [dataPath(), '/', exp_id, '/sorted/dead_times.txt'];

% Load
load(dh_times_file, 'dhTimes')
load(mea_file, 'Positions')
mea_map = double(Positions);

% Get All Triggers to process
triggers = [];
for i_dh = dh_sessions_to_process
    triggers = [triggers dhTimes{i_dh}.evtTimes_begin(:)'];
end

% Load the dead times
if exist([residuals_folder '/' residuals_file], 'file') && load_residuals
    load([residuals_folder '/' residuals_file], 'dead_init', 'dead_end');
    
% Or compute them if it had not been done before
else
    elec_residuals = computeElectrodeResiduals(raw_file, triggers, stim_duration, time_spacing, mea_map, encoding);
    mea_residual = computeMEAResidual([dead_electrodes, stim_electrodes], elec_residuals);
    [dead_init, dead_end] = computeDeadIntervals(mea_residual, time_spacing);
    
    % save
    save([tmpPath '/' residuals_file], 'dead_init', 'dead_end', 'time_spacing', 'stim_duration', 'mea_rate');
    save([tmpPath '/' residuals_file], 'elec_residuals', 'mea_residual', '-append');
    movefile([tmpPath '/' residuals_file], residuals_folder);
end

% Compute Dead Times for artifact Residuals
dead_times_artifacts = computeDeadTimes(triggers, dead_init, dead_end);

% Compute Dead Times on dh session to mask completely:
dead_times_covered = zeros(numel(dh_sessions_to_mask), 2);
for i_dh = dh_sessions_to_mask
    dead_init = dhTimes{i_dh}.evtTimes_begin(1) - time_spacing;
    dead_end = dhTimes{i_dh}.evtTimes_end(end) + time_spacing;
    dead_times_covered(i_dh, :) =  [dead_init dead_end];
end

% Put together and sort all dead times
dead_times = [dead_times_artifacts; dead_times_covered];
[~, order] = sort(dead_times(:,1));
dead_times = dead_times(order, :);

writematrix(dead_times, dead_times_file,'Delimiter','tab')