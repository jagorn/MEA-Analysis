function plotFeaturePSTHs(expId, nCell)

load(getDatasetMat(), 'cellsTable', 'features_psths')
cell_index = ([cellsTable(:).experiment] == expId & [cellsTable(:).N] == nCell);
feature_vec = features_psths(cell_index, :);

plot(feature_vec, 'LineWidth', 1.2);
title(strcat("Exp. ", expId, ", Cell #", string(nCell)'));