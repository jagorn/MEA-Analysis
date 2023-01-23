clear
close all
clc

% input data
do_fit_nls = true;
my_class_suffix = "/home/fran_tr/Projects/MEA-Analysis/Articles/Typing/Non-linearities estimate/_data/lns_";
classes = ["RGC.4.4.", "RGC.3.8."];
model_name = "checks";

% params
nl_func = @funSigmoid;
params_0 = [0, 2, 0.1, 0.6];
params_lb = [-inf, 0, 0, 0];
params_ub = [+inf, +inf, 1, 1];
show_plots = true;

all_p_core = cell(numel(classes), 1);
all_p_residual = cell(numel(classes), 1);

% Fit Non-linearities.
if do_fit_nls
    for i_class = 1:numel(classes)
        class = classes(i_class);
        
        % load
        class_file = strcat(my_class_suffix, class, "_", model_name, ".mat");
        load(class_file, 'nls_core', 'nls_core_x', 'nls_residual', 'nls_residual_x');
        
        % fit
        params_fit_residual = fit_all_nl(nls_residual', nls_residual_x, nl_func, params_0, params_lb, params_ub, show_plots);
        suptitle(strcat("Class: ", class, ", Model: ", model_name, ". NLs for Residual Cells"));
        
        params_fit_core = fit_all_nl(nls_core', nls_core_x, nl_func, params_0, params_lb, params_ub, show_plots);
        suptitle(strcat("Class: ", class, ", Model: ", model_name, ". NLs for Core Cells"));
        save(class_file, 'params_fit_residual', 'params_fit_core', '-append');
    end

end

% Discrimination Test
for i_class = 1:numel(classes)
    class_name = classes(i_class);
    class_file = strcat(my_class_suffix, class_name, "_", model_name, ".mat");
    load(class_file, 'params_fit_residual', 'params_fit_core', 'nls_core', 'nls_residual');

    n_params_core = size(params_fit_core, 1);
    n_params_residual = size(params_fit_residual, 1);
    
    outcomes = ["FAILED", "SUCCESS"];
    x_fit_test = [params_fit_core; params_fit_residual];
%     x_raw_test = [nls_core'; nls_residual'];
    
    y_test = zeros(1, n_params_core + n_params_residual);
    y_test(1:n_params_core) = 1;

    [d_fit, p_fit, ~] = manova1(x_fit_test, y_test);
    outcome_fit = outcomes(d_fit + 1);
    
%     [d_raw, p_raw, ~] = manova1(x_raw_test, y_test);
%     outcome_raw = outcomes(d_rawt + 1);
    
    fprintf("\tManova Test on sigmoid fit for Class %s: %s (p-val = %f)\n", class_name, outcome_fit, p_fit);
%     fprintf("\tManova Test on raw curve for Class %s: %s (p-val = %f)\n", class_name, outcome_raw, p_raw);
    fprintf("\n");
end



function params_all = fit_all_nl(non_linearities, nl_x, nl_func, params_0, params_lb, params_ub, show_plots)

n_params_nl = numel(params_0);

% params_all containes all parameters for each nonlinearity to fit
n_nls = size(non_linearities, 1);
params_all = zeros(n_nls, n_params_nl);

% create the panel for plots
if show_plots
    max_n_columns = 5;
    n_rows = ceil(n_nls/max_n_columns);
    n_columns = min(max_n_columns, n_nls);
    figure();
end

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
    else
        params = lsqcurvefit(nl_func, params_0, nl_to_fit_x, nl_to_fit_y, params_lb, params_ub);
    end
    
    % plot
    if show_plots
        subplot(n_rows, n_columns, i_nl);
        hold on
        plot(nl_x, nl, 'b', 'LineWidth', 1.2);
        plot(nl_x, nl_func(params, nl_x), 'm', 'LineWidth', 1.2);
        xline(params(1));
        yline(params(3));
        yline(1-params(4));
        
        xlim([min(nl_x), max(nl_x)]);
        ylim([-0.2, 1.2]);
        legend({'Empirical', 'Func Fit'});
    end
    
    params_all(i_nl, :) = params;
end
end

% Non Linearity Functions
function y = funExp(params, x)
% PARAMETERS:
% 1) Linear Coefficient
% 2) Exponential Coefficient
% 3) Y Offset
y = params(1) * exp(params(2) * x) + params(3);
end

function y = funOffset(params, x)
% PARAMETERS:
% 1) offset
% 2) Y Offset
y =  x * 0 + params;
end

function y = funRelu(params, x)
% PARAMETERS:
% 1) X Offset
% 2) Linear Coefficient
% 3) Y Offset
y = max((x - params(1)) * params(2), 0)  + params(3);
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