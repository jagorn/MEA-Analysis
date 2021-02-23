clear
close all;
% figure();

load('STA_filters.mat', 'STA_filters')
load('Degu N1 269.spiketimes3.mat')

params.meaRate = 20000; %Hz
isi_bins = 0:0.002:0.5;

temporal_stas = STA_filters(:, 1);
spatial_stas = STA_filters(:, 2);
n_cells = size(STA_filters, 1);

cells_idx = true(1, n_cells);

for i_cell = 1:n_cells
    spike_times = SpikeTimes{i_cell};
    spatial_sta = spatial_stas{i_cell};
    [xEll, yEll, ~, ~] =  fitEllipse(smoothSpatialSta(spatial_sta));
    
    [is_valid, meanRatio] = validateEllipse(xEll, yEll, smoothSpatialSta(spatial_sta));
%     cells_idx(i_cell) = is_valid;
    

    
%     if is_valid
            spatialSTAs(i_cell) = polyshape(xEll, yEll);
            t = temporal_stas{i_cell};
            temporalSTAs(i_cell, :) = t(8:end);
            
            
            spike_intervals = diff(spike_times) / params.meaRate;
            isi(i_cell, :) = histcounts(spike_intervals, isi_bins, 'Normalization', 'probability');
            isi(i_cell, :) = isi(i_cell, :) / max(isi(i_cell, :));
            
            traces(i_cell, :) = [isi(i_cell, :) temporalSTAs(i_cell, :), sqrt(area(spatialSTAs(i_cell))/pi)];
%     end
% 
%     subplot(1, 2, 1);
%     imagesc(smoothSpatialSta(spatial_sta));
%     colorbar();
%     hold on
%     plot(polyshape(xEll, yEll))
%     title(num2str(meanRatio));
%     hold off
% 
%     subplot(1, 2, 2);
%     bar(isi_bins(1:end-1), isi(i_cell, :));
%     
%     waitforbuttonpress();

    
end

spatialSTAs = spatialSTAs(cells_idx);
temporalSTAs = temporalSTAs(cells_idx, :);
isi = isi(cells_idx, :);
traces = traces(cells_idx, :);
cellsIds = find(cells_idx);
experiments = {'Degus'};
stas = spatial_stas(cells_idx);

[cellsTable, tracesMat] = buildDatasetTable({'Degus'}, {cellsIds}, {traces});

createEmptyDataset('Degus')
save(getDatasetMat, 'cellsTable', 'tracesMat');
save(getDatasetMat(), 'experiments', 'temporalSTAs', 'spatialSTAs', 'params', 'stas', 'isi', 'isi_bins', 'params', '-append')
