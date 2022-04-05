clear
close all

load('/home/fran_tr/Projects/MEA-Analysis/Thesis/Typing/Data/mosaics_comparison.mat')
load('/home/fran_tr/Projects/MEA-Analysis/Thesis/Typing/typing_colors.mat')

mosaics_classes = {'RGC.8.2.1.', 'RGC.8.2.4_PRUNED.', 'RGC.4.4.', 'RGC.3.8.'};


figure();
i_plot = 0;
for i_class = 1:numel(mosaics_classes)
    % Write here your query and the figures_path
    class_name = mosaics_classes{i_class};

    class_idx = strcmp(class_name, [mosaicsTable.class]);
    sta_classification_entry = mosaicsTable(class_idx);
    
    class_file = strcat('/home/fran_tr/Projects/MEA-Analysis/Thesis/Typing/', class_name, 'mat');
    load(class_file, 'cellsTable');
    load(class_file, 'non_linearities_sta', 'nl_x_sta', 'cells_sta');
    load(class_file, 'non_linearities_both', 'nl_x_both', 'cells_both');

    symbol_id = strcmp(class_name, names);
    symbol = symbols(symbol_id);
    color = colors(symbol_id, :);
    
    % plot
    i_plot = i_plot + 1;
    subplot(2, 2, i_plot);
    hold on
    k = plot_std_surface(non_linearities_sta, nl_x_sta, 'k');
    r = plot_std_surface(non_linearities_both, nl_x_both, color);
    
    xlim([min(nl_x_both), max(nl_x_both)]);
    ylim([-0.1, 1.1]);    
    
    xlabel('Generator signal');
    ylabel('Spiking Probability');
    
    title(strcat("Cluster ", symbol), 'Interpreter', 'None')
    legend([k, r], {'Cells only in STA mosaic', 'Cells in both mosaics'}, 'location', 'northwest')
end
suptitle("average non-linearities");

function p = plot_std_surface(ys, x, color)

avgY = mean(ys, 1);
stdY = std(ys, [], 1);
stdY_up = avgY + stdY / 2;
stdY_down = avgY - stdY / 2;

x_plot = [x, fliplr(x)];
y_plot = [stdY_up, fliplr(stdY_down)];

x_plot(isnan(y_plot)) = [];
y_plot(isnan(y_plot)) = [];

fill(x_plot, y_plot, color, 'EdgeColor', 'None', 'facealpha', 0.5);
p = plot(x, avgY, '.-', 'Color', color, 'LineWidth', 1.2);
end
