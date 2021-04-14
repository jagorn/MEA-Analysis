function computeAllActivations(pattern_keywords, act_label, ctrl_win, resp_win, min_z, min_fr)

load(getDatasetMat, 'psths', 'activations');

if ~exist('psths', 'var')
    error_struct.message = strcat(getDatasetId(), " has no psths yet");
    error_struct.identifier = strcat('MEA_Analysis:', mfilename);
    error(error_struct);
end

if ~exist('activations', 'var')
    activations = [];
end

all_patterns = fields(psths);
patterns2keywords = false(numel(all_patterns), numel(pattern_keywords));
for i_kw = 1:numel(pattern_keywords)
    kw = pattern_keywords{i_kw};
    patterns2keywords(:, i_kw) = contains(all_patterns, kw);
end
kw_patterns = all_patterns(all(patterns2keywords, 2));


for i_pattern = 1:numel(kw_patterns)
    pattern = kw_patterns(i_pattern);
    
    responses = psths.(pattern).psths;
    time_seq = psths.(pattern).time_sequences;
    [z, threshold] = estimateZscore(responses, time_seq, ctrl_win, resp_win, min_z, min_fr);
    
    activations.(pattern).(act_label).z = z;
    activations.(pattern).(act_label).threshold = threshold;
    activations.(pattern).(act_label).params.ctrl_win = ctrl_win;
    activations.(pattern).(act_label).params.resp_win = resp_win;
    activations.(pattern).(act_label).params.min_z = min_z;
    activations.(pattern).(act_label).params.min_fr = min_fr;
    
end

save(getDatasetMat(), 'activations', '-append');







