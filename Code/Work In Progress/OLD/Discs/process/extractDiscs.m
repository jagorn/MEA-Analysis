clear

% Parameters
discs_mat_file = [stimPath '/Discs/180704_PairedPulseBg_230_Manip.mat'];
discs_vec_file = [stimPath '/Discs/180704_PairedPulseBg_230_Manip.vec'];
img_id = 1;  % the suffix of image corresponding to discs manip.

% Paths
exp_id = getExpId();
vars_path = [dataPath(), '/' exp_id '/processed'];
discs_path = [vars_path() '/Discs'];
stims_order_file = [vars_path '/stims_order.txt'];

% Stim Triggers
load([vars_path '/EvtTimes.mat'], 'evtTimes')
disp("EvtTimes Loaded")

% Spike Times
load([vars_path '/SpikeTimes.mat'], 'SpikeTimes')
disp("Spike Times Loaded")

% Retrieve the order of Stimulations
stims_order = importdata(stims_order_file);
discs_index = contains(stims_order, 'DISCS');

% Discs Repetitions
discs_triggers = evtTimes{discs_index}.evtTimes_begin;
discs_stim_info = getDiscsStimInfo(discs_mat_file, discs_vec_file);
discs_reps = getDiscsRepetitions(discs_triggers, discs_stim_info);
discs_reps = transformDiscs2MEA(discs_reps, exp_id, img_id);

save([tmpPath() '/' 'Discs_RepetitionTimes.mat'], 'discs_reps')
movefile([tmpPath() '/' 'Discs_RepetitionTimes.mat'], discs_path)
save(getDatasetMat, 'discs_reps', '-append')