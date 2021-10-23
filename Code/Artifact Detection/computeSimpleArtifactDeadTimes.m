function [dead_times, artifact] = computeSimpleArtifactDeadTimes(triggers, mea_rate, raw_file, varargin)

% Default Parameters
dead_electrodes_def = [];
stim_electrodes_def = [127 128 255 256];
frame_duration_def = [];
time_padding_def = 0.2;
encoding_def = 'uint16';
mea_map_def = double(getMeaPositions());
artifact_def = [];

% Parse Input
p = inputParser;
addRequired(p, 'triggers');
addRequired(p, 'mea_rate');
addRequired(p, 'raw_file');
addParameter(p, 'Artifact', artifact_def);
addParameter(p, 'Dead_Electrodes', dead_electrodes_def);
addParameter(p, 'Stim_Electrodes', stim_electrodes_def);
addParameter(p, 'Frame_Duration', frame_duration_def);
addParameter(p, 'Time_Padding', time_padding_def);
addParameter(p, 'Endcoding', encoding_def);
addParameter(p, 'MEA_Map', mea_map_def);

parse(p, triggers, mea_rate, raw_file, varargin{:});

artifact = p.Results.Artifact;
dead_electrodes = p.Results.Dead_Electrodes;
stim_electrodes = p.Results.Stim_Electrodes;
frame_duration = p.Results.Frame_Duration;
time_padding = p.Results.Time_Padding;
encoding = p.Results.Endcoding;
mea_map = p.Results.MEA_Map;

if isempty(frame_duration)
    frame_duration = round(min(diff(triggers)) / mea_rate);
end

% If the artifacts are not given, compute them
if isempty(artifact)    
    elec_residuals = computeElectrodeResiduals(raw_file, triggers, frame_duration*mea_rate, time_padding*mea_rate, mea_map, encoding);
    mea_residual = computeMEAResidual([dead_electrodes, stim_electrodes], elec_residuals);
    [dead_init, dead_end] = computeDeadIntervals(mea_residual, time_padding*mea_rate);
    
    % save
    artifact.artifact_electrodes = elec_residuals;
    artifact.artifact_mea = mea_residual;
    artifact.dead_init = dead_init;
    artifact.dead_end = dead_end;
    artifact.params.time_spacing = time_padding;
    artifact.params.stim_duration = frame_duration;
    artifact.params.mea_rate = mea_rate;
end

% Compute Dead Times for artifact Residuals
dead_times = computeDeadTimes(triggers, artifact.dead_init, artifact.dead_end);
