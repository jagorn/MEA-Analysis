clear

mea_rate = 20000;
accepted_tag = 3;
evt_sessions = 1:5;
bin_dt = 0.05;
n_cells_panel = 40;

load('SpikeTimes.mat');
load('EvtTimes.mat');
load('Tags.mat');

good_tags = find(tags >= accepted_tag);
n_cells = numel(good_tags);
n_panels = ceil(n_cells / n_cells_panel);

for i_panel = 1:n_panels
    
    figure();
    fullScreen();
    cell_id = (i_panel-1)*n_cells_panel + 1;
    cell_idx = cell_id:min(cell_id+40, n_cells);
    
    for i_session = 1:numel(evt_sessions)
        session_id = evt_sessions(i_session);
        subplot(1, numel(evt_sessions), i_session);
        repetitions = evtTimes{session_id}.evtTimes_begins;
        repetitions_ends = evtTimes{session_id}.evtTimes_ends;
        n_steps_stim = median(repetitions_ends - repetitions);
        
        bin_size = round(bin_dt*mea_rate);
        n_bins = round(n_steps_stim / bin_size);
%         [psth, xpsth, mean_psth, firing_rates] = doPSTH(spikes, repetitions, bin_size, n_bins,  mea_rate, good_tags(cell_idx));

        
        plotCellsRaster(spikes, repetitions, n_steps_stim, mea_rate, 'Point_Size', 3, 'Cells_Indices', good_tags(cell_idx))
    end
    panel_name = strcat('rd1_raster_', num2str(evt_sessions(1)),'to', num2str(evt_sessions(end)), '#', num2str(i_panel));
    export_fig(panel_name, '-svg');
    close();
end

