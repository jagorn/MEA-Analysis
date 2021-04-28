i_cell = 46;
color_idx = [1 2 4 7  9 15];
idx_patterns = 33:38;

% Load Spikes
load(getDatasetMat(), "spikes");
load(getDatasetMat(), "params");
load(getDatasetMat(), "dh");

% Load Triggers of DH Spots
load(getDatasetMat(), "experiments");
assert(numel(experiments) == 1)
reps_file = [dataPath '/' char(experiments{1}) '/processed/DH/DHRepetitions.mat'];

cell_spikes = spikes{i_cell};

% Get all Stim Repetitions
load(reps_file, "zero_begin_time");
load(reps_file, "single_begin_time");
load(reps_file, "test_begin_time");


close all
figure()
reps_patterns = test_begin_time(idx_patterns);
labels = yPatternLabels(dh.stimuli.test(idx_patterns, :));

colors = getColors(max(color_idx));
colors = colors(color_idx, :);

plotStimRaster(cell_spikes, reps_patterns, 0.5, 0.5, 20000, labels, colors)
axis off
