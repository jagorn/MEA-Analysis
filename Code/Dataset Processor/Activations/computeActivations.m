function computeActivations(pattern, psth_label, act_label, ctrl_win, resp_win, min_z, min_fr)

load(getDatasetMat, 'psths', 'activations');

if ~exist('psths', 'var')
    error_struct.message = strcat(getDatasetId(), " has no psths yet");
    error_struct.identifier = strcat('MEA_Analysis:', mfilename);
    error(error_struct);
end

if ~exist('activations', 'var')
    activations = [];
end

if ~isfield(psths, pattern) || ~isfield(psths.(pattern), psth_label)
    error_struct.message = strcat(getDatasetId(), " has no psth called ", psth_label, " for pattern ", pattern);
    error_struct.identifier = strcat('MEA_Analysis:', mfilename);
    error(error_struct);
end

responses = psths.(pattern).(psth_label).psths;
time_seq = psths.(pattern).(psth_label).time_sequences;
[z, threshold] = estimateZscore(responses, time_seq, ctrl_win, resp_win, min_z, min_fr);

activations.(pattern).(psth_label).(act_label).z = z;
activations.(pattern).(psth_label).(act_label).threshold = threshold;
activations.(pattern).(psth_label).(act_label).params.ctrl_win = ctrl_win;
activations.(pattern).(psth_label).(act_label).params.resp_win = resp_win;
activations.(pattern).(psth_label).(act_label).params.min_z = min_z;
activations.(pattern).(psth_label).(act_label).params.min_fr = min_fr;

save(getDatasetMat(), 'activations', '-append');






