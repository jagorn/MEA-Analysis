function computeAllActivations(pattern, label_keywords, act_label, ctrl_win, resp_win, min_z, min_fr)

load(getDatasetMat, 'psths', 'activations');

if ~exist('psths', 'var')
    error_struct.message = strcat(getDatasetId(), " has no psths yet");
    error_struct.identifier = strcat('MEA_Analysis:', mfilename);
    error(error_struct);
end

if  ~isfield(psths, pattern)
    error_struct.message = strcat(getDatasetId(), " has no psths for the pattern ", pattern);
    error(error_struct);
end

if ~exist('activations', 'var')
    activations = [];
end

all_psths = fields(psths.(pattern));
label2keywords = false(numel(all_psths), numel(label_keywords));
for i_kw = 1:numel(label_keywords)
    kw = label_keywords{i_kw};
    label2keywords(:, i_kw) = contains(all_psths, kw);
end
kw_labels = all_psths(all(label2keywords, 2));


for i_pattern = 1:numel(kw_labels)
    psth_label = kw_labels{i_pattern};
        
    responses = psths.(pattern).(psth_label).psths;
    time_seq = psths.(pattern).(psth_label).time_sequences;
    time_bin = psths.(pattern).(psth_label).t_bin;
    [z, threshold] = estimateZscore(responses, time_seq, time_bin, ctrl_win, resp_win, min_z, min_fr);
    
    activations.(pattern).(psth_label).(act_label).z = z;
    activations.(pattern).(psth_label).(act_label).threshold = threshold;
    activations.(pattern).(psth_label).(act_label).params.ctrl_win = ctrl_win;
    activations.(pattern).(psth_label).(act_label).params.resp_win = resp_win;
    activations.(pattern).(psth_label).(act_label).params.min_z = min_z;
    activations.(pattern).(psth_label).(act_label).params.min_fr = min_fr;
    
end

save(getDatasetMat(), 'activations', '-append');







