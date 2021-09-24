function plotComparisonExpSTA(exp_id, cell_id, condition1, condition2, varargin)

p = inputParser;
addRequired(p, 'exp_id');
addRequired(p, 'cell_id');
addRequired(p, 'condition1');
addOptional(p, 'condition2', []);
addParameter(p, 'Zooming_Factor', 0.2);

parse(p, exp_id, cell_id, condition1, varargin{:});
condition2 = p.Results.condition2;
zoom_factor = p.Results.Zooming_Factor;

mea_rate = getMeaRate(exp_id);
spike_times = getSpikeTimes(exp_id);

[temporal1, spatial1, rfs1, valid1] = getSTAsComponents(exp_id, 'Label', condition1);
[temporal2, spatial2, rfs2, valid2] = getSTAsComponents(exp_id, 'Label', condition2);


if isempty(condition1) || strcmp(condition1, "")
    condition1 = "simple";
end
if isempty(condition2) || strcmp(condition2, "")
    condition2 = "simple";
end

figure('Name', ['Cell_#' num2str(cell_id)]);

% ISI
subplot(2, 4, 1)
plotInterSpikeInterval(spike_times{cell_id}, mea_rate)
title('ISI');

% Temporal STA
subplot(2, 4, 5)
hold on

if any(valid1 == cell_id)
    plot((-20/30):(1/30):0, temporal1(cell_id, :), 'r', 'LineWidth', 1.5)
end

if any(valid2 == cell_id)
    plot((-20/30):(1/30):0, temporal2(cell_id, :), 'b', 'LineWidth', 1.5)
end

legend({condition1, condition2})
title('temporal STA');



% Receptive Field
subplot(2, 4, [2, 3, 6, 7])
spatial_img = ones(size(spatial1, 2), size(spatial1, 3), 3) * 0.3;

if any(valid1 == cell_id)
    rf1 = rfs1(cell_id);
    spatial_sta1 = squeeze(spatial1(cell_id, :, :));
    spatial_img(:, :, 1) = spatial_sta1 / max(spatial_sta1(:));
end

if any(valid2 == cell_id)
    rf2 = rfs2(cell_id);
    spatial_sta2 = squeeze(spatial2(cell_id, :, :));
    spatial_img(:, :, 3) = spatial_sta2 / max(spatial_sta2(:));
end

imagesc(spatial_img);

if any(valid1 == cell_id)
    hold on
    [x1, y1] = boundary(rf1);
    plot(x1, y1, 'r', 'LineWidth', 1.5)
end
if any(valid2 == cell_id)
    hold on
    [x2, y2] = boundary(rf2);
    plot(x2, y2, 'b', 'LineWidth', 1.5)
end

daspect([1 1 1])
axis off
[u_len, v_len, ~] = size(spatial_img);
xlim([v_len*zoom_factor, v_len*(1-zoom_factor)])
ylim([u_len*zoom_factor, u_len*(1-zoom_factor)])
title('Receptive Field');


subplot(2, 4, 8)
if any(valid1 == cell_id)
    
    rf = rfs1(cell_id);
    spatial_sta = squeeze(spatial1(cell_id, :, :));
    
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
    title(condition1)
end

subplot(2, 4, 4)
if any(valid2 == cell_id)
    
    rf = rfs2(cell_id);
    spatial_sta = squeeze(spatial2(cell_id, :, :));
    
    background = spatial_sta;
    background = background - min(background(:));
    background = background / max(background(:)) * 255;
    colormap('summer');
    imagesc(background);
    
    hold on
    [x, y] = boundary(rf);
    plot(x, y, 'b', 'LineWidth', 1.5)
    
    daspect([1 1 1])
    axis off
    [u_len, v_len] = size(background);
    xlim([v_len*zoom_factor, v_len*(1-zoom_factor)])
    ylim([u_len*zoom_factor, u_len*(1-zoom_factor)])
    title(condition2)
end

h = suptitle(strcat("Exp: ", exp_id, " Cell#", num2str(cell_id)));
h.Interpreter = 'none';
fullScreen();
