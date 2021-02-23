function plotDiscsControl(i_cell)

loadDataset();
sessions = ["Discx10_DIM", "Discx40_DIM", "Discx10_DIM_SIDE", "Discx40_DIM_SIDE"];

colors = getColors(10);
colors = colors([1 3 4 5 6], :);

figure()
fullScreen();
for i_plot = 1:numel(sessions)
    subplot(1, 6, i_plot)
    discs = eval(sessions(i_plot));
    disc_idx = 2:numel(discs);

    labels = strings(1, numel(disc_idx));
    for i_label = 1:numel(disc_idx)
        i_disc = disc_idx(i_label);
        labels(i_label) = string(['r = ' num2str(discs(i_disc).disc_radius) ' pxls']);
    end
    plotDiscsPsths(i_cell, discs, disc_idx, discs_params, colors, labels)
    title(sessions(i_plot), 'Interpreter', 'None');
end

subplot(3, 3, [6 9])
plotSSTAs(i_cell)
for disc = discs
    viscircles([disc.disc_center_x/20, disc.disc_center_y/20], disc.disc_radius/20, 'Color', 'k')
    
    DMD_PxlSize = 2.5;
    Checkerboard_PxlsPerSquare = 20;
    dist = 8.5 * 30 / DMD_PxlSize;
        
    viscircles([disc.disc_center_x/20, disc.disc_center_y/20 + dist/20], disc.disc_radius/20, 'Color', 'b')
    text(disc.disc_center_x/20, disc.disc_center_y/20 + dist/20, '?', 'HorizontalAlignment', 'center', 'Color', 'b')

end

subplot(3, 3, 3)
plotTSTAs(i_cell)
title(['cell #' num2str(i_cell)]);
