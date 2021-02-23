clear
close all

figure()
subplot(2,2,1)
plot_analysis('20191011_grid', 'dh_wild', 'LNP', 'ON')
subplot(2,2,2)
plot_analysis('20191011_grid', 'dh_wild', 'LNP', 'OFF')
subplot(2,2,3)
plot_analysis('20191011_grid', 'dh_lap4_acet_bis', 'LNP', 'ON')
subplot(2,2,4)
plot_analysis('20191011_grid', 'dh_lap4_acet_bis', 'LNP', 'OFF')

function plot_analysis(exp_id, session_label, model, polarity)
idx_spots = [2:6, 9:13, 16:20, 23:27, 30:34];

if strcmp(polarity, 'ON')
    idx_cells = [17 61 83 85];
    color = 'r';
elseif strcmp(polarity, 'OFF')
    idx_cells = [45 51 56 60 64 100 101 133 137];
    color = 'b';
else 
    error('cell polarity must be ON or OFF');
end

load(getDatasetMat, session_label);

spots = getDHSpotsCoordsMEA(exp_id, session_label, idx_spots);
[rfcs, radiuses] = getRFCenterPositionsMEA(exp_id, idx_cells);

n_spots = size(spots, 1);
n_cells = size(rfcs, 1);

distances = zeros(n_cells, n_spots);
weights = zeros(n_cells, n_spots);

for i_cell = 1:n_cells
    index_cell = idx_cells(i_cell);
    rfc = rfcs(i_cell, :);
    radius = radiuses(i_cell, :);


    [ws, a, b] = getDHLNPWeights(index_cell, session_label, model);

    
    for i_spot = 1:n_spots
        index_spot = idx_spots(i_spot);

        spot = spots(i_spot, :);
        distances(i_cell, i_spot) = (pdist([rfc; spot])) / radius;
        weights(i_cell, i_spot) = ws(index_spot) * a;
    end
end

dist_v = distances(:);
ws_v = weights(:);
nbins = 15;

minV  = min(dist_v);
maxV  = max(dist_v);
delta = (maxV-minV)/nbins;
dist_intevals = linspace(minV, maxV, nbins)-delta/2.0;

histw = cell(nbins, 1);
for i=1:length(dist_v)
ind = find(dist_intevals < dist_v(i), 1, 'last' );
if ~isempty(ind)
  histw{ind} = [histw{ind}  ws_v(i)];
end
end


hold on
mean_weights = cellfun(@mean, histw);
std_weights = cellfun(@std, histw);
bar(dist_intevals, mean_weights, color)
errorbar(dist_intevals, mean_weights,std_weights, 'k')

xlabel('Receptive Field Center - Spot Normalized Distance')
ylabel('Weights')
title(session_label, 'Interpreter', 'None')

% ylim([-1.2, 1.2])s

end

