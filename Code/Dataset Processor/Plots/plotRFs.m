function plotRFs(indices, varargin)
% Plots the mosaic of receptive fields of a set of cells
%
% Parameters;
% indices:                     the id numbers of the cells
% Zooming_Factor (optional):   zoom factor (0 = no zoom, 0.5 = *2 zoom).

p = inputParser;
addRequired(p, 'indices');
addParameter(p, 'Zooming_Factor', 0.2);

parse(p, indices, varargin{:});
zoom_factor = p.Results.Zooming_Factor;

load(getDatasetMat(), 'RFs');
rfs = RFs(indices);

colormap gray

colors = getColors(sum(indices>0));
background = ones(51, 38)*255;

image(background);

hold on

for i = 1:size(rfs, 2)
    [x, y] = boundary(rfs(i));
    plot(x, y, 'Color', colors(i, :), 'LineWidth', 1.5)
end

daspect([1 1 1])
axis off


[u_len, v_len] = size(background);
xlim([v_len*zoom_factor, v_len*(1-zoom_factor)])
ylim([u_len*zoom_factor, u_len*(1-zoom_factor)])

title('receptive fields')