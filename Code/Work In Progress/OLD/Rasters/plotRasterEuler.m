function plotRasterEuler(cell_indices, expId)

load(getDatasetMat, 'spikes', 'params');
[rep_begin_time_20khz,rep_end_time_20khz, euler] = getEulerRepetitions(expId);

figure
subplot(2, 1, 1)
plot(euler)
xticks([]);
yticks([]);
title("Euler Chirp")
subplot(2, 1, 2)
plotRaster(cell_indices, spikes, rep_begin_time_20khz, rep_end_time_20khz, params.meaRate)
title("Spikes Raster")
suptitle("Euler Raster")




