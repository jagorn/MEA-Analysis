clear
close all

load('/home/fran_tr/Projects/MEA-Analysis/Thesis/Typing/Data/mosaics_comparison.mat')
load('/home/fran_tr/Projects/MEA-Analysis/Thesis/Typing/typing_colors.mat')

nl_func = @funSigmoid;


for entry = 1:numel(mosaicsTable)
    
    sta_classification_entry = mosaicsTable(entry);
    class_name = sta_classification_entry.class;
    
    i_sym = names == class_name;
    symbol = symbols(i_sym);
    color = colors(i_sym, :);
    
    class_file = strcat(class_name, 'mat');
    output_file = strcat("Data_Fit/SigmoidFit_", symbol, ".mat");
    
    try
    load(class_file, 'non_linearities_sta', 'nl_x_sta', 'cells_sta');
    load(class_file, 'non_linearities_both', 'nl_x_both', 'cells_both');
    catch
        fprintf("Warning: class %s not found.\n", symbol);
        continue;
    end
    
    figure()
    [params_sta hessian_sta] = fit_all_nl(non_linearities_sta, nl_x_sta, nl_func);
    suptitle(strcat(" Cluster ", symbol, ", RF-BASED only"));

    figure();
    [params_both hessian_both]  = fit_all_nl(non_linearities_both, nl_x_both, nl_func);
    suptitle(strcat(" Cluster ", symbol, ", Chirp-BASED"));
    
    waitforbuttonpress();
    close all
    
    save(output_file, 'params_sta', 'params_both', 'hessian_sta', 'hessian_both');
end


function [params_all, hessians_all] = fit_all_nl(non_linearities, nl_x, nl_func)

% params_all containes all parameters for each nonlinearity to fit
n_nls = size(non_linearities, 1);
params_all = zeros(n_nls, 4);
hessians_all = {};

% create the panel for plots
max_n_columns = 5;
n_rows = ceil(n_nls/max_n_columns);
n_columns = min(max_n_columns, n_nls);

i_p = 1;
for i_nl = 1:n_nls
    nl = non_linearities(i_nl, :);
    x = nl_x;
    
    % keep only definite values
    nl_idx_fit = ~isnan(nl);
    nl_idx_fit2 = (x > -0.6) & x < (1.6);
    nl_idx_fit = nl_idx_fit & nl_idx_fit2;
    
    nl_to_fit_x = x(nl_idx_fit);
    nl_to_fit_y = nl(nl_idx_fit);
    
    % fit the nl function
    [params_sing, residual] = lsqcurvefit(@funOffset, 0, nl_to_fit_x, nl_to_fit_y, -inf, +inf, optimoptions('LSQCURVEFIT','Display','off'));
    if residual < 0.01
        continue;
    else
        [params, hessian] =  my_fit(nl_to_fit_x, nl_to_fit_y);
    end
    
    params_all(i_p, :) = params;
    hessians_all{i_p} = hessian;
    
    % plot
    subplot(n_rows, n_columns, i_p);
    hold on
    plot(nl_x, nl, 'b', 'LineWidth', 1.2);
    plot(nl_x, nl_func(params, nl_x), 'm', 'LineWidth', 1.2);
    xlim([min(nl_x), max(nl_x)]);
    ylim([-0.2, 1.2]);
    legend({'Empirical', 'Func Fit'});
    
    i_p = i_p + 1;
end
end