function [rfc_coords, rf_radiuses] = getRFCenterPositionsMEA(exp_id, idx_cells)

load(getDatasetMat, 'spatialSTAs');
if ~exist('idx_cells', 'var')
    idx_cells = 1:numel(spatialSTAs);
end

n_cells = sum(idx_cells>0);
sstas = spatialSTAs(idx_cells);
[x, y] = centroid(sstas);

H1 = getHomography('dmd', 'img');
H2 = getHomography('img3', 'mea', exp_id);

rfc_coords_dmd = [x(:), y(:)];
rfc_coords = transformPointsV(H2*H1, rfc_coords_dmd);

rf_radiuses = zeros(n_cells, 1);
for i = 1:n_cells
    sta = sstas(i);
    trasf_vertices = transformPointsV(H2*H1, sta.Vertices);
    rf_radiuses(i) = sqrt(polyarea(trasf_vertices(:, 1), trasf_vertices(:, 2)) / pi);

%     figure()
%     scatter(trasf_vertices(:, 1), trasf_vertices(:, 2))
%     hold on
%     scatter(rfc_coords(i, 1), rfc_coords(i, 2))
%     close
end

