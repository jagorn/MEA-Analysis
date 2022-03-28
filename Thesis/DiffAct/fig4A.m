clear
close all

dataset_id = '20210517_gtacr_noSTAs';
exp_id = '20210517_gtacr';

mea_rate = 20000;
on_cell_id = 66;     % 12
off_cell_id = 56;   % 54

psth_pattern = 'flicker';
activation_labels = {'on', 'off'};

psth_label_visual = 'simple';
psth_label_opto = 'lap4_acet_30nd50p';

section_id_visual = '5-flicker';
section_id_opto = '15-flicker_(lap4_acet_30nd50p)';
pattern_id = 3;

color_active_ON = [1, 0, 0; 1, 0, 0];
color_active_OFF = [0, 0, 1; 0, 0, 1];

x_lims = [-0.5, 2.5];
up_bound = 80;

changeDataset(dataset_id);
load(getDatasetMat(), 'psths', 'activations', 'cellsTable');

spike_times = getSpikeTimes(exp_id);
on_cell_N = cellsTable(on_cell_id).N;
off_cell_N = cellsTable(off_cell_id).N;

repetitions_visual = getRepetitions(exp_id, section_id_visual);
n_steps_visual = repetitions_visual.durations{pattern_id};
rep_begin_visual = repetitions_visual.rep_begins{pattern_id};

repetitions_opto = getRepetitions(exp_id, section_id_opto);
n_steps_opto = repetitions_opto.durations{pattern_id};
rep_begin_opto = repetitions_opto.rep_begins{pattern_id};


subplot(4, 2, 1);
title('ON Cell (visual response)');
plotActivations(on_cell_id, psth_pattern, psth_label_visual, activation_labels, ...
    'Show_Stimulus', 'blocks', ...
    'Show_Stimulus_Block_As_Luminance', true, ...
    'Upper_Bound', up_bound, ...
    'Show_Legend', false, ...
    'PSTHS', psths, ...
    'ACTIVATIONS', activations, ...
    'Colors_Active_One', color_active_ON);
xlim(x_lims)

subplot(4, 2, 5);
title('ON Cell (optogenetic response)');
plotActivations(on_cell_id, psth_pattern, psth_label_opto, activation_labels, ...
    'Show_Stimulus', 'blocks', ...
    'Show_Stimulus_Block_As_Luminance', true, ...
    'Upper_Bound', up_bound, ...
    'Show_Legend', false, ...
    'PSTHS', psths, ...
    'ACTIVATIONS', activations, ...
    'Colors_Active_One', color_active_ON);
xlim(x_lims)

subplot(4, 2, 2);
plotCellsRaster(spike_times(on_cell_N), rep_begin_visual, n_steps_visual, mea_rate, 'Raster_Colors', [1, 0, 0]);
title('ON Cell (visual response)');
xlim(x_lims)

subplot(4, 2, 6);
plotCellsRaster(spike_times(on_cell_N), rep_begin_opto, n_steps_opto, mea_rate, 'Raster_Colors', [1, 0, 0]);
title('ON Cell (optogenetic response)');
xlim(x_lims)

subplot(4, 2, 3);
title('OFF Cell (visual response)');
plotActivations(off_cell_id, psth_pattern, psth_label_visual, activation_labels, ...
    'Show_Stimulus', 'blocks', ...
    'Show_Stimulus_Block_As_Luminance', true, ...
    'Upper_Bound', up_bound, ...
    'Show_Legend', false, ...
    'PSTHS', psths, ...
    'ACTIVATIONS', activations, ...
    'Colors_Active_One', color_active_OFF);
xlim(x_lims)


subplot(4, 2, 7);
title('OFF Cell (optogenetic response)');
plotActivations(off_cell_id, psth_pattern, psth_label_opto, activation_labels, ...
    'Show_Stimulus', 'blocks', ...
    'Show_Stimulus_Block_As_Luminance', true, ...
    'Upper_Bound', up_bound, ...
    'Show_Legend', false, ...
    'PSTHS', psths, ...
    'ACTIVATIONS', activations, ...
    'Colors_Active_One', color_active_OFF);
xlim(x_lims)

subplot(2, 4, 7);
plotCellsRaster(spike_times(off_cell_N), rep_begin_visual, n_steps_visual, mea_rate, 'Raster_Colors', [0, 0, 1]);
title('OFF Cell (visual response)');
xlim(x_lims)

subplot(2, 4, 8);
plotCellsRaster(spike_times(off_cell_N), rep_begin_opto, n_steps_opto, mea_rate, 'Raster_Colors', [0, 0, 1]);
title('OFF Cell (optogenetic response)');
xlim(x_lims)
