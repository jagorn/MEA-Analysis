clear
close all
load('strychnine');

dt_psth = 0.05;
ctrl_win = [0, 1];
resp_win = [1.5, 2.5];
k = 5;
min_fr = 10;

% Polarity
polarities = getPolarity(sta_temporal, 1:10);
for i_p = 1:numel(polarities)
    cellsTable(i_p).polarity = polarities(i_p);
end

on_idx = find(polarities == "ON");
off_idx = find(polarities == "OFF");
onoff_idx = find(polarities == "ON-OFF");
none_idx = find(polarities == "NONE");

% Distance 

% Activation
[z_control, t_up_control, t_down_control] = estimateZscore2sides(psth_surround_control, t_surround_psth, dt_psth, ctrl_win, resp_win, k, min_fr);
[z_strychnine, t_up_strychnine, t_down_strychnine] = estimateZscore2sides(psth_surround_strychnine, t_surround_psth, dt_psth, ctrl_win, resp_win, k, min_fr);

% Plots

% Save
save('strychnine', 'cellsTable', '-append');