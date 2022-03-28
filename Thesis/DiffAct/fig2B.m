clear
close all

exp_id = '20210302_reachr2';
mea_rate = 20000;
on_cell_id = 23;
off_cell_id = 1;

psth_pattern = 'flicker';
activation_labels = {'on', 'off'};

psth_label_visual = 'simple';
psth_label_opto = 'lap4_acet_30nd100p';

section_id_visual = '4-flicker';
section_id_opto = '30-flicker_(lap4_acet_30nd100p)';
pattern_id = 3;

color_active_one = [1, 0, 0; 0, 0, 1];
x_lims = [-0.5, 2.5];
up_bound = 80;

changeDataset(exp_id);
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
    'Colors_Active_One', color_active_one);
xlim(x_lims)
xlabel('Time (s)');
ylabel('Firing Rate (Hz)');

subplot(4, 2, 5);
title('ON Cell (optogenetic response)');
plotActivations(on_cell_id, psth_pattern, psth_label_opto, activation_labels, ...
    'Show_Stimulus', 'blocks', ...
    'Show_Stimulus_Block_As_Luminance', true, ...
    'Upper_Bound', up_bound, ...
    'Show_Legend', false, ...
    'PSTHS', psths, ...
    'ACTIVATIONS', activations, ...
    'Colors_Active_One', color_active_one);
xlim(x_lims)
xlabel('Time (s)');
ylabel('Firing Rate (Hz)');

subplot(4, 2, 3);
plotCellsRaster(spike_times(on_cell_N), rep_begin_visual, n_steps_visual, mea_rate, 'Raster_Colors', [1, 0, 0]);
title('ON Cell (visual response)');
xlim(x_lims)
ylabel('Repetitions');

subplot(4, 2, 7);
plotCellsRaster(spike_times(on_cell_N), rep_begin_opto, n_steps_opto, mea_rate, 'Raster_Colors', [1, 0, 0]);
title('ON Cell (optogenetic response)');
xlim(x_lims)
ylabel('Repetitions');


subplot(4, 2, 2);
title('OFF Cell (visual response)');
plotActivations(off_cell_id, psth_pattern, psth_label_visual, activation_labels, ...
    'Show_Stimulus', 'blocks', ...
    'Show_Stimulus_Block_As_Luminance', true, ...
    'Upper_Bound', up_bound, ...
    'Show_Legend', false, ...
    'PSTHS', psths, ...
    'ACTIVATIONS', activations, ...
    'Colors_Active_One', color_active_one);
xlim(x_lims)
xlabel('Time (s)');
ylabel('Firing Rate (Hz)');

subplot(4, 2, 6);
title('OFF Cell (optogenetic response)');
plotActivations(off_cell_id, psth_pattern, psth_label_opto, activation_labels, ...
    'Show_Stimulus', 'blocks', ...
    'Show_Stimulus_Block_As_Luminance', true, ...
    'Upper_Bound', up_bound, ...
    'Show_Legend', false, ...
    'PSTHS', psths, ...
    'ACTIVATIONS', activations, ...
    'Colors_Active_One', color_active_one);
xlim(x_lims)
xlabel('Time (s)');
ylabel('Firing Rate (Hz)');

subplot(4, 2, 4);
plotCellsRaster(spike_times(off_cell_N), rep_begin_visual, n_steps_visual, mea_rate, 'Raster_Colors', [0, 0, 1]);
title('OFF Cell (visual response)');
xlim(x_lims)
ylabel('Repetitions');

subplot(4, 2, 8);
plotCellsRaster(spike_times(off_cell_N), rep_begin_opto, n_steps_opto, mea_rate, 'Raster_Colors', [0, 0, 1]);
title('OFF Cell (optogenetic response)');
xlim(x_lims)
ylabel('Repetitions');
