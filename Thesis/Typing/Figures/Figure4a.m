clear
close all

do_shuffle = false;

load('/home/fran_tr/Projects/MEA-Analysis/Thesis/Typing/Data/mosaics_comparison.mat')
load('/home/fran_tr/Projects/MEA-Analysis/Thesis/Typing/typing_colors.mat')

mosaics_classes = {'RGC.8.2.1.', 'RGC.8.2.4_PRUNED.', 'RGC.4.4.', 'RGC.3.8.', 'RGC.4.2.', 'RGC.2.5.'};
mosaics_classes = {'RGC.8.2.1.', 'RGC.8.2.4_PRUNED.', 'RGC.4.4.', 'RGC.3.8.', 'RGC.4.2.', 'RGC.2.5.', 'RGC.1.1.', 'RGC.1.3.1.', 'RGC.3.1.', 'RGC.3.2.2.', 'RGC.6.3.1.'};


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
    
    
    if do_shuffle
        nls = [non_linearities_sta; non_linearities_both];
        nls_shuffled = nls(randperm(size(nls, 1)), :);
        non_linearities_sta = nls_shuffled(1:size(non_linearities_sta, 1), :);
        non_linearities_both = nls_shuffled((size(non_linearities_sta, 1) + 1) : end, :);
    end
    
    % plot
    i_plot = i_plot + 1;
    subplot(3, 4, i_plot);
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
