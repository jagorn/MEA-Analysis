function plotExpSTA(exp_id, cell_id)
[temporal, spatial, rfs, valid] = getSTAsComponents(exp_id);

if all(valid ~= cell_id)
    warning(strcat('no valid STA defactorization found for cell #', num2str(cell_id)));
    return
end

figure();
subplot(1, 2, 1);
plot(temporal(cell_id, :), "Color", 'r', "LineWidth", 1.5)
title('temporal component');

subplot(1, 2, 2);
rf = rfs(cell_id);
spatial_sta = squeeze(spatial(cell_id, :, :));

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
xlim([0, v_len])
ylim([0, u_len])

title('spatial component')

suptitle(strcat("Exp ", exp_id, " Cell# ", num2str(cell_id), ": Spike-Triggered Average"));