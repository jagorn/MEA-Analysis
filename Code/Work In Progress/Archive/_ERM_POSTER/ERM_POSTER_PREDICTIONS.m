clear
close all

i_cell = 79;

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


subplot(1, 2, 2);
plotDHHistogram(i_cell, "LNP")
yticks([]);
yticklabels([]);
title("Prediction")

% axis off

% subplot(1, 4, 1)
% idx_patterns = 1:50;
% reps_patterns = single_begin_time(idx_patterns);
% labels = yPatternLabels(dh.stimuli.singles(idx_patterns, :));
% plotStimRaster(cell_spikes, reps_patterns, 0.5, 0.5, 20000, labels)
% title("1 DH Spot")
% axis off
% ylabel("Holographic Activations")
% 
% subplot(1, 4, 2)
% idx_patterns = 51:100;
% reps_patterns = single_begin_time(idx_patterns);
% labels = yPatternLabels(dh.stimuli.singles(idx_patterns, :));
% plotStimRaster(cell_spikes, reps_patterns, 0.5, 0.5, 20000, labels)
% title("1 DH Spot")
% axis off

subplot(1, 2, 1)
reps_patterns = test_begin_time;
labels = yPatternLabels(dh.stimuli.test);
plotStimRaster(cell_spikes, reps_patterns, 0.5, 0.5, 20000, labels)
title("Multi DH Spot")
axis off

