function plotOnOffActivation(cell_idx, psth_pattern, psth_labels)

n_cells_by_plot = 5;
n_plots = ceil(numel(cell_idx)/n_cells_by_plot);

load(getDatasetMat(), 'psths', 'activations');
max_psth = 50;


for i_plot = 1:n_plots
    i_cell_start = 1 + n_cells_by_plot*(i_plot-1);
    i_cell_end = min(i_cell_start + n_cells_by_plot - 1, numel(cell_idx));
    plot_cells = cell_idx(i_cell_start:i_cell_end);
    
    figure()
    i_subplot = 1;
    
    for i_cell = plot_cells
        
        for i_label = 1:numel(psth_labels)
            psth_label = psth_labels{i_label};
            
            subplot(n_cells_by_plot, numel(psth_labels), i_subplot)
            
            if i_subplot <=  numel(psth_labels)
                title(psth_label, 'Interpreter', 'None');
            end
            
            if i_label == 1
                ylabel('firing rate (Hz)')
            end
            
            if i_cell == plot_cells(end)
                xlabel('time (s)')
            end
            
            i_subplot = i_subplot + 1;
            
            
            psth = psths.(psth_pattern).(psth_label).psths(i_cell, :);
            x_psth = psths.(psth_pattern).(psth_label).time_sequences;
            
            stim_pattern = getPatternProfile(psth_pattern);
            stim_rate =  psths.(psth_pattern).(psth_label).stim_rate;
            
            z_on = activations.(psth_pattern).(psth_label).on.z(i_cell);
            z_off = activations.(psth_pattern).(psth_label).off.z(i_cell);
            
            threshold_on = activations.(psth_pattern).(psth_label).on.threshold(i_cell);
            threshold_off = activations.(psth_pattern).(psth_label).off.threshold(i_cell);
            
            resp_win_on = activations.(psth_pattern).(psth_label).on.params.resp_win;
            resp_win_off = activations.(psth_pattern).(psth_label).off.params.resp_win;
            
            color_off = 'red';
            color_on = 'cyan';
            color_onoff = 'magenta';
            color_blank = 'k';
            
            if z_on && z_off
                color = color_onoff;
            elseif z_on
                color = color_on;
            elseif z_off
                color = color_off;
            else
                color = color_blank;
            end
            
            hold on
            plotStimStates(stim_pattern.profile, stim_rate, max_psth, true);
            plot(x_psth, psth, color, 'LineWidth', 2);
            plot(resp_win_on, [threshold_on threshold_on], color_on)
            plot(resp_win_off, [threshold_off threshold_off], color_off)
            ylim([0 max_psth])
        end
    end
end