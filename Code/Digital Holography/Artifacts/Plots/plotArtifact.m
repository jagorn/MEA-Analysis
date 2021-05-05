function plotArtifact(exp_id, varargin)

% Parameters Raw Files
label_def = [];
scale_mv_def = 1000;

% Parse Input
p = inputParser;
addRequired(p, 'exp_id');
addParameter(p, 'Label', label_def);
addParameter(p, 'Scale_mV', scale_mv_def);

parse(p, exp_id, varargin{:});
label = p.Results.Label; 
scale_mv = p.Results.Scale_mV; 

if isempty(label)
    artifacts_file = fullfile(sortedPath(exp_id), 'artifacts.mat');
else
    artifacts_file = fullfile(sortedPath(exp_id), strcat('artifacts_', label,'.mat'));
end


if ~isfile(artifacts_file)
    error_struct.message = strcat("DH Artifact ", label, " not found in ", exp_id);
    error_struct.identifier = strcat('MEA_Analysis:', mfilename);
    error(error_struct);
end

load(artifacts_file, 'dh_artifacts');
mea_map = getMeaPositions(exp_id);

if ~exist('dh_artifacts', 'var')
    error_struct.message = strcat("DH Artifact not found in ", exp_id);
    error_struct.identifier = strcat('MEA_Analysis:', mfilename);
    error(error_struct);
end

n_artifacts = numel(dh_artifacts);
if n_artifacts > 1
    n = 0;
    while ~(n > 0 && n <= n_artifacts)
    n = input(strcat(num2str(n_artifacts), " DH sessions were found: which artifact do you want to plot? (1 to ", num2str(n_artifacts), ")\n"));
    end
else
    n = 1;
end

traces = dh_artifacts(n).artifact_electrodes;

plotMEA();
plotGridMEA();
plotTracesMEA(traces, mea_map, 'Trace_Scale_mv', scale_mv)
title(strcat("Experiment ", exp_id, ", DH Artifact ", label, " (session#", num2str(n), ")"), 'Interpreter', 'None')
