% function importDHModel(model_label, session_label)

model_label = 'LNP';
session_label = 'DHMulti';
exp_id = '20200131_dh';

changeDataset(exp_id)

% Load accuracies
MODEL_MATRIX = [dataPath '/' exp_id '/processed/DH/models/' session_label '/' model_label '.mat'];
load(MODEL_MATRIX, "cells", "accuracy", "mse", "ws", "b", "mu", "std")
load(MODEL_MATRIX, 'predictions', 'truths')
load(getDatasetMat, 'cellsTable');


dh_session_struct = load(getDatasetMat, session_label);

n_cells = numel(cellsTable);
n_weights = size(ws, 2);
n_patterns = size(predictions, 2);

dh_session_struct.(session_label).(model_label).isModeled = boolean(zeros(n_cells, 1));
dh_session_struct.(session_label).(model_label).isModeled(cells) = true;


dh_session_struct.(session_label).(model_label).ws = zeros(n_cells, n_weights);
dh_session_struct.(session_label).(model_label).mu = zeros(n_cells, n_weights);
dh_session_struct.(session_label).(model_label).sigma = zeros(n_cells, n_weights);
for n = 1:length(cells)
    i = cells(n);
    dh_session_struct.(session_label).(model_label).ws(i, :) = squeeze(ws(n, :));
    dh_session_struct.(session_label).(model_label).mu(i, :) = squeeze(mu(n, :));
    dh_session_struct.(session_label).(model_label).sigma(i, :) = squeeze(std(n, :));
end

dh_session_struct.(session_label).(model_label).b = zeros(n_cells, 1);
dh_session_struct.(session_label).(model_label).b(cells) = b;

dh_session_struct.(session_label).(model_label).accuracies = zeros(n_cells, 1);
dh_session_struct.(session_label).(model_label).accuracies(cells) = accuracy;

dh_session_struct.(session_label).(model_label).rmses = zeros(n_cells, 1);
dh_session_struct.(session_label).(model_label).rmses(cells) = sqrt(mse);

dh_session_struct.(session_label).(model_label).predictions = zeros(n_cells, n_patterns);
dh_session_struct.(session_label).(model_label).firingRates = zeros(n_cells, n_patterns);
for n = 1:length(cells)
    i = cells(n);
    dh_session_struct.(session_label).(model_label).predictions(i, :) = predictions(n, :);
    dh_session_struct.(session_label).(model_label).firingRates(i, :) = truths(n, :);
end

% save
save(getDatasetMat, '-struct', 'dh_session_struct', "-append")
