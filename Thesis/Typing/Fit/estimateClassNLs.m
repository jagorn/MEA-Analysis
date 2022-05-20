clear
close all
global show_plots, show_plots = 1;

load('/home/fran_tr/Projects/MEA-Analysis/Thesis/Typing/Datasets/RGCMatrix.mat', 'classesTableNotPruned')
classTableRGC = classesTableNotPruned;

load('/home/fran_tr/Projects/MEA-Analysis/Thesis/Typing/Datasets/STAMatrix.mat', 'classesTableNotPruned')
classTableSTA = classesTableNotPruned;

load('/home/fran_tr/Projects/MEA-Analysis/Thesis/Typing/Data/mosaics_comparison.mat')
load('/home/fran_tr/Projects/MEA-Analysis/Thesis/Typing/typing_colors.mat')

figures_folder = "/home/fran_tr/Projects/MEA-Analysis/Thesis/Typing/Plots";
nl_func = @funSigmoid;
params_0 = [0, 1, 0.1, 0.6];
params_lb = [-inf, 0, 0, 0];
params_ub = [+inf, +inf, 1, 1];

for entry = 1:numel(mosaicsTable)
    
    % Write here your query and the figures_path
    sta_classification_entry = mosaicsTable(entry);
    class_name = sta_classification_entry.class;
    control_name = sta_classification_entry.bestControl;
    
    idx_rgc = classTableRGC([classTableRGC.name] == class_name).indices;
    idx_sta = classTableSTA([classTableSTA.name] == control_name).indices;
    
    
%     idx_rgc = sta_classification_entry.indices;
%     idx_sta = sta_classification_entry.controlIndices;
    
    i_sym = names == class_name;
    symbol = symbols(i_sym);
    color = colors(i_sym, :);
%     
%     if ~isequal(symbol, 'L')
%         continue;
%     end
    
    cells_both = find(idx_rgc & idx_sta);
    cells_sta = find(~idx_rgc & idx_sta);
    
%     try
%         [non_linearities_sta, nl_x_sta] = nl_loop(class_name, cells_sta, cellsTable, []);
%         [non_linearities_both, nl_x_both] = nl_loop(class_name, cells_both, cellsTable, []);
%     catch
%         fprintf("some nonlinearities could not be computed for group %s. This group will be skipped.\n", symbol);
%         continue;
%     end
    
    class_file = strcat(class_name, '_whole.mat');
    load(class_file, 'cellsTable', 'non_linearities_sta', 'nl_x_sta', 'cells_sta', 'non_linearities_both', 'nl_x_both', 'cells_both');

    
    params_sta = fit_all_nl(non_linearities_sta, nl_x_sta, nl_func, params_0, params_lb, params_ub);
    params_both = fit_all_nl(non_linearities_both, nl_x_both, nl_func, params_0, params_lb, params_ub);
%     save(class_file, 'params_sta', 'params_both', '-append');
    
    % plot
    figure();
    hold on
    k = plot_std_surface(non_linearities_sta, nl_x_sta, 'k');
    r = plot_std_surface(non_linearities_both, nl_x_both, color);
    
    xlim([min(nl_x_both), max(nl_x_both)]);
    ylim([-0.1, 1.1]);
    
    xlabel('Generator signal');
    ylabel('Spiking Probability');
    
    title(strcat(symbol, " average non-linearity"), 'Interpreter', 'None')
    legend([k, r], {'Cells only in STA mosaic', 'Cells in both mosaics'}, 'location', 'northwest')
    
    all_nls_figure_file = fullfile(figures_folder, strcat(symbol, '_NLs'));
    saveas(gcf, all_nls_figure_file,'jpg')
    pause(2);
    close();
end

function [non_linearities , nl_x] = nl_loop(class_name, cells_to_check, cellsTable, figures_path)

non_linearities = [];
for i_cell = cells_to_check(:)'
    
    cell_id = cellsTable(i_cell).N;
    exp_id = cellsTable(i_cell).experiment;
    
    do_plots = ~isempty(figures_path);
    
    try
        [non_linearity, nl_x] = estimateNL(cell_id, exp_id, true, do_plots);
    catch error
        disp(error.message);
        continue
    end
    
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
p = plot(x, avgY, '.-', 'Color', color, 'LineWidth', 1.2);
end

function params_all = fit_all_nl(non_linearities, nl_x, nl_func, params_0, params_lb, params_ub)

global show_plots;
n_params_nl = numel(params_0);

% params_all containes all parameters for each nonlinearity to fit
n_nls = size(non_linearities, 1);
params_all = zeros(n_nls, n_params_nl);

% create the panel for plots
if show_plots
    max_n_columns = 5;
    n_rows = ceil(n_nls/max_n_columns);
    n_columns = min(max_n_columns, n_nls);
    show_plots = show_plots + 1;
    figure(show_plots);
end

i_p = 1;
for i_nl = 1:n_nls
    nl = non_linearities(i_nl, :);
    x = nl_x;
    
    % keep only definite values
    nl_idx_fit = ~isnan(nl);
    nl_to_fit_x = x(nl_idx_fit);
    nl_to_fit_y = nl(nl_idx_fit);
    
    % fit the nl function
    [params_sing, residual] = lsqcurvefit(@funOffset, 0, nl_to_fit_x, nl_to_fit_y, -inf, +inf);
    if residual < 0.01
        params = [params_sing, 0, 0, 1-params_sing];
%         continue;
    else
        params = lsqcurvefit(nl_func, params_0, nl_to_fit_x, nl_to_fit_y, params_lb, params_ub);
    end
    
    % plot
    if show_plots
        subplot(n_rows, n_columns, i_p);
        hold on
        plot(nl_x, nl, 'b', 'LineWidth', 1.2);
        plot(nl_x, nl_func(params, nl_x), 'm', 'LineWidth', 1.2);
        xlim([min(nl_x), max(nl_x)]);
        ylim([-0.2, 1.2]);
        legend({'Empirical', 'Func Fit'});
    end
    
    params_all(i_p, :) = params;
    i_p = i_p + 1;
end
waitforbuttonpress();

end

function y = funSigmoid(params, x)
% PARAMETERS:
% 1) X Offset
% 2) Sigmoid Coefficient
% 3) Y Lower bound  (between 0 and 1)
% 4) Y Upper bound (between 0 and 1)

y = 1 ./ (1 + exp(-params(2) * (x - params(1))));
y = params(3) + y * (1 - params(3) - params(4));
end

function y = funOffset(params, x)
% PARAMETERS:
% 1) offset
% 2) Y Offset
y =  x * 0 + params;
end