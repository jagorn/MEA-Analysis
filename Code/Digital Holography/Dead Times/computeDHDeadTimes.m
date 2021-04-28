function computeDHDeadTimes(exp_id, raw_file, mea_rate)

% path
dead_times_file = fullfile(sortedPath(exp_id), 'dead_times.txt');
dh_articats_file = fullfile(sortedPath(exp_id), 'artifacts.mat');

% get the DH times.
try
    dhTimes = getDHTimes(exp_id);
catch
    dhTimes = extractDHTimes(exp_id, raw_file, mea_rate);
end

% compute the artifacts and dead times
full_dead_times = [];
for i_dh = 1:numel(dhTimes)
    triggers_begin = dhTimes{i_dh}.evtTimes_begin;
    triggers_end = dhTimes{i_dh}.evtTimes_end;
    
    duration = min(triggers_end - triggers_begin);
    [dead_times, artifact] = computeSimpleArtifactDeadTimes(triggers, mea_rate, raw_file, 'Frame_Duration', duration);
    full_dead_times = [full_dead_times; dead_times];
    dh_artifacts(i_dh) = artifact;
end

% sort dead times
[~, order] = sort(full_dead_times(:,1));
full_dead_times = full_dead_times(order, :);

writematrix(dead_times_file, 'full_dead_times', 'Delimiter', 'tab');
save(dh_articats_file, 'dh_artifacts');

