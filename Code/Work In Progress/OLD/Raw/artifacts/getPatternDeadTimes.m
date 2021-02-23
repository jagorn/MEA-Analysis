function dead_times = getPatternDeadTimes(exp_id, session_id, type_id, pattern_ids)

file_path = [dataPath '/' char(exp_id) '/processed/DH/artifacts'];

for id_pattern = pattern_ids
    file_name = [char(session_id) '_' char(type_id) '_' num2str(id_pattern) '_residuals.mat'];
    load([file_path '/' file_name], 'dead_init', 'dead_end');
    dead_times{id_pattern}.begin = dead_init;
    dead_times{id_pattern}.end = dead_end;
end


