clear
close all

do_plot = true;
do_save = false;

experiments = ["20210326", "20211007", "20211109"];
stimuli = ["surround_flash_control", "surround_flash_strychnine"];  % , "surround_flash_washout"

n_stim = numel(stimuli);

dt_stim = 1.0;
dt_spacing = 1.0;
repetitions_idx = 1:4:60*4;

rate = 20000;
t_bin = 0.05;

bin_size = t_bin * rate;
n_bins = (dt_stim + dt_spacing * 2) / t_bin;

n_columns = 3;


load('strychnine.mat', 'cellsTable');
for experiment = experiments(:)'
    
    datafile_offsets = strcat(experiment, "_recordings_offsets.mat");
    datafile_spikes = strcat("Data/hdf5/", experiment, "_recording_0.result.hdf5");
    
    spikes = readSpikeTimes(datafile_spikes);
    good_cells_idx = ([cellsTable.experiment] == experiment) & ( ([cellsTable.grade] == 'A') | ([cellsTable.grade] == 'B') );
    good_cells = [cellsTable(good_cells_idx).N] + 1;
    
    if do_plot
        figure();
        fullScreen();
    end
    
    for i_stim = 1:n_stim
        stimulus = stimuli(i_stim);
        
        datafile_repetitions = strcat("Data/repetitions/", experiment, "_", stimulus, ".mat");
        if ~exist(datafile_repetitions, 'file')
            continue
        end
        load(datafile_repetitions, 'repetitions');
        
        load(datafile_offsets, stimulus);
        offset = double(eval(stimulus));
        
        r = repetitions(repetitions_idx) + offset - dt_spacing*rate;
        
        [psth, t_psth, mean_psth, firing_rates] = doPSTH(spikes, r, bin_size, n_bins,  rate, 1:numel(spikes));
        psths.(stimulus) = psth;
        
        if do_plot
            
            i_chunk = 1;
            for i_col = i_stim : n_stim : (n_stim * n_columns)
                
                n_cells_column = floor(numel(good_cells) / n_columns);
                
                start_cells = 1 + n_cells_column * (i_chunk - 1);
                end_cells = min(n_cells_column * i_chunk, numel(good_cells));
                cell_idx = good_cells(start_cells : end_cells);
                i_chunk = i_chunk + 1;
                
                subplot(1, n_columns * n_stim, i_col);
                plotCellsRaster(spikes, repetitions(repetitions_idx) + offset, dt_stim * rate, rate, ...
                    'Title', stimulus, ...
                    'Labels', cell_idx - 1, ...
                    'Point_Size', 3, ...
                    'Post_Stim_DT', dt_spacing, ...
                    'Pre_Stim_DT', dt_spacing, ...
                    'Cells_Indices', cell_idx);
            end
        end
    end
    
    if do_plot
        suptitle(experiment);
        waitforbuttonpress();
        export_fig(strcat('Strychnine_raster_', experiment, '.svg'));
        close();
    end
    
    if do_save
        datafile_psths = strcat("Data/", experiment, "_surround_psths.mat");
        save(datafile_psths, 'psths', 't_psth');
    end
end