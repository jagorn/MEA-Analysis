clear
close all

load('/home/fran_tr/Projects/MEA-Analysis/Thesis/Typing/Data/mosaics_comparison.mat')
[sta_scores_sorted, sta_entries_sorted] = sort([mosaicsTable.bestControlScore], 'descend');
worst_sta_entries = sta_entries_sorted(end-3: end);
figures_folder = "NL Comparison";

for entry = worst_sta_entries(:)'
    % Write here your query and the figures_path
    sta_classification_entry = mosaicsTable(entry);
    class_name = sta_classification_entry.class;
    
    class_folder = fullfile(figures_folder, class_name);
    mkdir(class_folder);
    
    figure_path_both = fullfile(class_folder, strcat('BothMethods_', class_name));
    cells_both = find(sta_classification_entry.indices & sta_classification_entry.controlIndices);
    [non_linearities_both, nl_x_both] = nl_loop(class_name, cells_both, cellsTable, figure_path_both);
    
    figure_path_stas = fullfile(class_folder, strcat('StaMethod_', class_name, '_nl'));
    cells_sta = find(~sta_classification_entry.indices & sta_classification_entry.controlIndices);
    [non_linearities_sta, nl_x_sta] = nl_loop(class_name, cells_sta, cellsTable, figure_path_stas);
    
    class_file = strcat(class_name, '.mat');
    save(class_file, 'cellsTable');
    save(class_file, 'non_linearities_sta', 'nl_x_sta', 'cells_sta', '-append');
    save(class_file, 'non_linearities_both', 'nl_x_both', 'cells_both', '-append');

    % plot
    figure();
    hold on
    k = plot_std_surface(non_linearities_sta, nl_x_sta, 'k');
    r = plot_std_surface(non_linearities_both, nl_x_both, 'r');
    
    xlim([min(nl_x_both), max(nl_x_both)]);
    ylim([-0.1, 1.1]);    
    
    xlabel('Generator signal');
    ylabel('Spiking Probability');
    
    title(strcat(class_name, " average non-linearity"), 'Interpreter', 'None')
    legend([k, r], {'Cells only in STA mosaic', 'Cells in both mosaics'}, 'location', 'northwest')

    all_nls_figure_file = fullfile(figures_folder, strcat(class_name, '_nl_comparison'));
    saveas(gcf, all_nls_figure_file,'jpg')
    close();
end


function [non_linearities , nl_x] = nl_loop(class_name, cells_to_check, cellsTable, figures_path)

non_linearities = [];
for i_cell = cells_to_check(:)'
    
    cell_id = cellsTable(i_cell).N;
    exp_id = cellsTable(i_cell).experiment;
    
    do_plots = ~isempty(figures_path);
    [non_linearity, nl_x] = estimateNL(cell_id, exp_id, true, do_plots);
    
    if do_plots
        suptitle(strcat("Experiment ", exp_id, " Cell #", num2str(cell_id), " (Class ", class_name, ")"));
        figure_file = strcat(figures_path, "_", num2str(cell_id), "_", exp_id);
        saveas(gcf, figure_file,'jpg')
        close();
    end
    
    non_linearities = [non_linearities; non_linearity];
end
end


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
p = plot(x, avgY, strcat(color, '.-'), 'LineWidth', 1.2);
end
