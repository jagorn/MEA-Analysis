clear
close all

% selected_cells = [];
mea_rate = 20000;
accepted_tag = 3;
evt_session = 1;
n_cells_panel = 20;
dt_euler = 25;

load('SpikeTimes.mat');
load('Euler_Triggers.mat', 'repetitions')
load('Tags.mat');

reps = repetitions{evt_session};
good_tags = find(tags >= accepted_tag);
n_cells = numel(good_tags);
n_columns = ceil(n_cells / n_cells_panel);

figure();
fullScreen();

for i_column = 1:2
    
    cell_id = (i_column-1)*n_cells_panel + 1;
    cell_idx = cell_id:min(cell_id+40, n_cells);
    n_steps_stim = round(dt_euler * mea_rate);

    subplot(1, 2, i_column);
    plotCellsRaster(spikes, reps, n_steps_stim, mea_rate, ...
                    'Point_Size', 3, ...
                    'Pre_Stim_DT', 0, ...
                    'Post_Stim_DT', 0, ...
                    'Cells_Indices', good_tags(cell_idx));
end

panel_name = strcat('rd1_euler_', num2str(evt_session));
export_fig(panel_name, '-svg');
export_fig(panel_name, '-svg');
close();