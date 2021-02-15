function plotSSTA(cell_id, varargin)
% Plots spatial factor of the STA for a given cell
%
% Parameters;
% indices:                     the id number of the cell
% Zooming_Factor (optional):   zoom factor (0 = no zoom, 0.5 = *2 zoom).

p = inputParser;
addRequired(p, 'cell_id');
addParameter(p, 'Zooming_Factor', 0.2);

parse(p, cell_id, varargin{:});
zoom_factor = p.Results.Zooming_Factor;


load(getDatasetMat(), 'spatialSTAs', 'RFs');
rf = RFs(cell_id);
spatial_sta = squeeze(spatialSTAs(cell_id, :, :));

background = spatial_sta;
background = background - min(background(:));
background = background / max(background(:)) * 255;
colormap('summer');
imagesc(background);

hold on
[x, y] = boundary(rf);
plot(x, y, 'r', 'LineWidth', 1.5)

daspect([1 1 1])
axis off

[u_len, v_len] = size(background);
xlim([v_len*zoom_factor, v_len*(1-zoom_factor)])
ylim([u_len*zoom_factor, u_len*(1-zoom_factor)])

title('receptive field')