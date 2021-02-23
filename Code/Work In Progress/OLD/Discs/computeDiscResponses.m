loadDataset();

% params
discs.params.initial_offset = -.2; % seconds
discs.params.final_offset = +.3; % seconds
discs.params.time_bin = 0.05; % seconds
% discs.params.time_res = 1/10; % seconds

n_cells = numel(cellsTable);
n_discs = numel(discs_reps);
dt = discs_reps(1).dt;
dt_white1 = discs_reps(1).dt_white_init;
dt_black2 = discs_reps(1).dt_black_middle;
dt_white3 = discs_reps(1).dt_white_end;

discs.dt_background0 =  [discs.params.initial_offset           0];
discs.dt_white1 =       [discs.dt_background0(2)        discs.dt_background0(2)     + dt_white1];
discs.dt_black2 =       [discs.dt_white1(2)             discs.dt_white1(2)          + dt_black2];
discs.dt_white3 =       [discs.dt_black2(2)             discs.dt_black2(2)          + dt_white3];
discs.dt_background4 =  [discs.dt_white3(2)             discs.dt_white3(2)          + discs.params.final_offset];

discs.resp_duration = discs.dt_background4(2) - discs.dt_background0(1);
discs.stim_duration = dt;

bin_size = discs.params.time_bin * params.meaRate; 
n_bins = round(discs.resp_duration / discs.params.time_bin);
n_bins_baseline = round(-discs.params.initial_offset / discs.params.time_bin);
    
discs.psths = zeros(n_cells, n_discs, n_bins);
discs.baselines = zeros(n_cells, n_discs*n_bins_baseline);
for i_disc = 1:numel(discs_reps)
    
    rep_begin = discs_reps(i_disc).rep_begin + discs.params.initial_offset*params.meaRate;
    [psth, x_psth, ~] = doPSTH(spikes, rep_begin, bin_size, n_bins, params.meaRate, 1:numel(spikes));
    [baselines, ~, ~] = doPSTH(spikes, rep_begin, bin_size, n_bins_baseline, params.meaRate, 1:numel(spikes));

    discs.psths(:, i_disc, :) = psth;
    discs.baselines(:, (n_bins_baseline*(i_disc-1)) + (1:n_bins_baseline)) = baselines;
end
discs.t_psths = x_psth + discs.params.initial_offset;

save(getDatasetMat(), 'discs', '-append');