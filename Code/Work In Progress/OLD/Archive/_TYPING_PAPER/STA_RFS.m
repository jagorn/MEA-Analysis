% Which Cells should we show here? Same of Rasters?
% How do we scale (or normalize) the STAs?

expId = '20181018a';
exp_indices = 1:9;

exp_cells = find(expIndices(expId));
cell_indices = exp_cells(exp_indices);

figure()
i_plot = 0;
i_cell = 0;
for i_row = 1:3
    for i_col = 1:2:6
        
        i_cell = i_cell + 1;
        cell_id = cell_indices(i_cell)
        
        i_plot = i_plot +1;
        subplot(3, 6, i_plot);
                
        sta = getSTAFrame(cell_id);
        rf = spatialSTAs(cell_id);
        imagesc(sta);
        hold on
        [x, y] = boundary(rf);
        plot(x, y, 'Color', 'k', 'LineWidth', 1.5)
        ylim([51/2 - 10, 51/2 + 10])
        xlim([38/2 - 10, 38/2 + 10])
        axis off
        pbaspect([1 1 1])
        
        i_plot = i_plot +1;
        subplot(3, 6, i_plot);
        
        ssta = temporalSTAs(cell_id, :);
        plot(ssta, 'Color', 'k', 'LineWidth', 1);
        ylim([-5, 5])
        axis off
    end
end

saveas(gcf, '/home/fran_tr/Desktop/Typing_Paper/sta_rfs','pdf')
