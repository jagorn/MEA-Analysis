function computeDHDeadTimes(exp_id, mea_rate, varargin)

% Parameters Raw Files
raw_path_def = sortedPath(exp_id);
raw_name_def = exp_id;
label_def = [];

% Parse Input
p = inputParser;
addRequired(p, 'exp_id');
addRequired(p, 'mea_rate');
addParameter(p, 'Raw_Filtered_Path', raw_path_def);
addParameter(p, 'Raw_Filtered_Name', raw_name_def);
addParameter(p, 'Label', label_def);

parse(p, exp_id, mea_rate, varargin{:});
raw_path = p.Results.Raw_Filtered_Path; 
raw_name = p.Results.Raw_Filtered_Name; 
label = p.Results.Label; 

% path
raw_file = fullfile(raw_path, strcat(raw_name, '.raw'));

if isempty(label)
    dead_times_file = fullfile(sortedPath(exp_id), 'dead_times.txt');
    dh_artifats_file = fullfile(sortedPath(exp_id), 'artifacts.mat');
else
    dead_times_file = fullfile(sortedPath(exp_id), strcat('dead_times_', label, '.txt'));
    dh_artifats_file = fullfile(sortedPath(exp_id), strcat('artifacts_', label,'.mat'));
end


% get the DH times.
try
    dhTimes = getDHTimes(exp_id);
catch
    error_struct.message = strcat("DH Times not found in ", exp_id);
    error_struct.identifier = strcat('MEA_Analysis:', mfilename);
    error(error_struct);
end

% compute the artifacts and dead times
full_dead_times = [];
for i_dh = 1:numel(dhTimes)
    triggers_begin = dhTimes{i_dh}.evtTimes_begin;
    triggers_end = dhTimes{i_dh}.evtTimes_end;
    
    duration = median(triggers_end - triggers_begin) / mea_rate;
    fprintf('\n detecting artifacts on a %f seconds window\n', duration);
    [dead_times, artifact] = computeSimpleArtifactDeadTimes(triggers_begin, mea_rate, raw_file, 'Frame_Duration', duration);
    full_dead_times = [full_dead_times; dead_times];
    dh_artifacts(i_dh) = artifact;
end

% sort dead times
[~, order] = sort(full_dead_times(:,1));
full_dead_times = full_dead_times(order, :);

writematrix(full_dead_times, dead_times_file, 'Delimiter', 'tab');
save(dh_artifats_file, 'dh_artifacts');
disp('artifact computed');

