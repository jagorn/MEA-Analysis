function plotOnOffActivation(psth_pattern, varargin)
% Funtion to plot a cell's psth and its activation to a certain stimulus

% Parse Input
p = inputParser;
addRequired(p, 'psth_pattern');
addParameter(p, 'Conditions', []);
addParameter(p, 'Show_Stimulus', 'trace');                   % it can be 'trace', 'blocks' or 'none'
addParameter(p, 'Show_Stimulus_Block_As_Luminance', false);  
addParameter(p, 'Upper_Bound', 50);
addParameter(p, 'One_By_One', false);
addParameter(p, 'Output_Folder', []);

parse(p, psth_pattern, varargin{:});
psth_labels = p.Results.Conditions;
show_stimulus = p.Results.Show_Stimulus;
show_blocks_as_luminance = p.Results.Show_Stimulus_Block_As_Luminance;
max_psth = p.Results.Upper_Bound;
plot_1by1 = p.Results.One_By_One;
output_folder = p.Results.Output_Folder;


activation_labels = {'on', 'off'};
activation_colors = [1, 0, 0; 0, 0, 1];
activation_color_all = [1, 0, 1];


load(getDatasetMat(), 'psths', 'activations', 'cellsTable');
cell_idx = 1:numel(cellsTable);

if isempty(psth_labels)
    psth_labels = fields(activations.(psth_pattern));
end

n_plot_rows = 5;
n_plot_columns = numel(psth_labels) + 1;
n_plots = ceil(numel(cell_idx)/n_plot_rows);


for i_plot = 1:n_plots
    
    i_cell_start = 1 + n_plot_rows*(i_plot-1);
    i_cell_end = min(i_cell_start + n_plot_rows - 1, numel(cell_idx));
    plot_cells = cell_idx(i_cell_start:i_cell_end);
    
    figure();
    fullScreen();
    i_subplot = 1;
    
    for i_cell = plot_cells
        
        % Plot STAs in the first columns
        subplot(n_plot_rows, n_plot_columns, i_subplot)
        plotTSTAs(i_cell)
        axis off;
        i_subplot = i_subplot +1;
        
        % Plot PSTHs
        
        for i_label = 1:numel(psth_labels)
            psth_label = psth_labels{i_label};
            
            
            subplot(n_plot_rows, n_plot_columns, i_subplot)
            
            if i_subplot <=  n_plot_columns
                title(split(psth_label, '_'));
            end
            
            if i_label == 1
                ylabel('firing rate (Hz)')
            end
            
            if i_cell == plot_cells(end)
                xlabel('time (s)')
            end
            
            if (i_label == numel(psth_labels)) && (i_cell == plot_cells(1))
                show_legend = true;
            else
                show_legend = false;
            end
            
            plotActivations(i_cell, psth_pattern, psth_label, activation_labels, ...
                'Colors_Active_One', activation_colors, ...
                'Color_Active_All', activation_color_all, ...
                'Show_Stimulus', show_stimulus, ...
                'Show_Stimulus_Block_As_Luminance', show_blocks_as_luminance, ...
                'Upper_Bound', max_psth, ...
                'Show_Legend', show_legend, ...
                'PSTHS', psths, ...
                'ACTIVATIONS', activations);
            
            i_subplot = i_subplot +1;
        end
    end
    
    if ~isempty(output_folder)
        file_name = strcat(getDatasetId, "_", psth_pattern, "_Activations#", num2str(i_plot));
        filepath = fullfile(output_folder, file_name);
        export_fig(filepath, '-svg');
        close;
    elseif plot_1by1
        waitforbuttonpress();
        close();
    end
end