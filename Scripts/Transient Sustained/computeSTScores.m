function computeSTScores(pattern, psth_label, st_label, sust_win, trans_win)

load(getDatasetMat, 'psths', 'st_scores');

if ~isfield(psths, pattern) || ~isfield(psths.(pattern), psth_label)
    error_struct.message = strcat(getDatasetId(), " has no psth called ", psth_label, " for pattern ", pattern);
    error_struct.identifier = strcat('MEA_Analysis:', mfilename);
    error(error_struct);
end

responses = psths.(pattern).(psth_label).psths;
time_seq = psths.(pattern).(psth_label).time_sequences;
time_bin = psths.(pattern).(psth_label).t_bin;

scores = estimateSTscore(responses, time_seq, time_bin, sust_win, trans_win);

st_scores.(st_label).scores = scores;
st_scores.(st_label).params.sust_win = sust_win;
st_scores.(st_label).params.trans_win = trans_win;
st_scores.(st_label).params.psth_pattern = pattern;
st_scores.(st_label).params.psth_label = psth_label;

save(getDatasetMat(), 'st_scores', '-append');






