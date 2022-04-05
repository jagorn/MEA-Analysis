clear
close all
load('strychnine');

% Parameters PSTH
dt_psth = 0.05;

% Parameters Activation
ctrl_win = [0, 1];
resp_win = [1.5, 2.5];
k = 5;
min_fr = 10;

% Parameters Registration
check_size_pxl = 30;
pxl_size_microns = 3.5;
surround_edge = 19;

% Variables
n_cells = numel(cellsTable);
check_size_microns = check_size_pxl * pxl_size_microns;

rfs(n_cells) = polyshape();
distance_surround = zeros(1, n_cells);

% Polarity
polarities = getPolarity(sta_temporal, 1:10);
for i_p = 1:n_cells
    cellsTable(i_p).polarity = polarities(i_p);
end

for i_cell = 1:n_cells
    
    % Receptive Fields
    frame_sta = squeeze(sta_spatial(i_cell, :, :));
    [xEll, yEll, ~, ~] =  fitEllipse(frame_sta);
    rfs(i_cell) = polyshape(xEll, yEll);
    
    % Distance
    lowest = max(yEll);
    distance_checks = surround_edge - lowest;
    distance_microns = distance_checks * check_size_microns;
    distance_surround(i_cell) = distance_microns;
end


% Activation
[z_control, t_up_control, t_down_control] = estimateZscore2sides(psth_surround_control, t_surround_psth, dt_psth, ctrl_win, resp_win, k, min_fr);
[z_strychnine, t_up_strychnine, t_down_strychnine] = estimateZscore2sides(psth_surround_strychnine, t_surround_psth, dt_psth, ctrl_win, resp_win, k, min_fr);

activations.control.z = z_control;
activations.control.t_up = t_up_control;
activations.control.t_udown = t_down_control;
activations.strychnine.z = z_strychnine;
activations.strychnine.t_up = t_up_strychnine;
activations.strychnine.t_udown = t_down_strychnine;

% Save
save('strychnine', 'cellsTable', 'rfs', 'activations', 'distance_surround', '-append');