clear
close all

nl_func = @funSigmoid;
params_0 = [0, 1, 0.1, 0.6];
params_lb = [-inf, 0, 0, 0];
params_ub = [+inf, +inf, 1, 1];

show_plots = false;
n_trials = 1000;

load('/home/fran_tr/Projects/MEA-Analysis/Thesis/Typing/typing_colors.mat')

class_names = {'RGC.8.2.1.', 'RGC.8.2.4_PRUNED.', 'RGC.4.4.', 'RGC.3.8.'};
figure()

for i_c = 1:numel(class_names)
    subplot(2, 2, i_c);
    
    class_name = class_names{i_c};
    class_folder = strcat('/home/fran_tr/Projects/MEA-Analysis/Thesis/Typing/', class_name, 'mat');
    
    symbol_id = strcmp(class_name, names);
    symbol = symbols(symbol_id);
    color = colors(symbol_id, :);
    
    
    % fit
    load(class_folder);
    params_sta = fit_all_nl(non_linearities_sta, nl_x_sta, nl_func, params_0, params_lb, params_ub, show_plots);
    params_both = fit_all_nl(non_linearities_both, nl_x_both, nl_func, params_0, params_lb, params_ub, show_plots);
    
    % train gaussian classifier
    params_data = [params_both; params_sta];
    labels = cell(size(params_data, 1), 1);
    
    % write labels
    for y_both = 1:size(params_both, 1)
        labels{y_both} = 'BOTH';
    end
    for y_both = (size(params_both, 1)+1):numel(labels)
        labels{y_both} = 'STA_ONLY';
    end
    
    gaussian_classifier = fitcnb(params_data,labels, 'ClassNames', {'BOTH', 'STA_ONLY'});
    gaussian_params = cell2mat(gaussian_classifier.DistributionParameters);
    
    
    loss = resubLoss(gaussian_classifier);
    
    % control: try to classify shuffled classes
    control_loss = zeros(1, n_trials);
    for i = 1:n_trials
        idx_perm = randperm(size(params_data, 1));
        while all(idx_perm == (1:numel(idx_perm)))
            idx_perm = randperm(size(params_data, 1));
        end
        params_data_shuffled = params_data(idx_perm, :);
        
        gaussian_classifier = fitcnb(params_data_shuffled, labels, 'ClassNames', {'BOTH', 'STA_ONLY'});
        control_loss(i) = resubLoss(gaussian_classifier);
    end
    
    hold on
    histogram(control_loss, 0:0.05:0.8, 'Normalization', 'probability', 'FaceColor', color);
    xline(loss, 'k', 'LineWidth', 2)
    xlim([-0.1, 0.7]);
    ylim([0, 0.8]);
    xlabel('Loss Values (a. u.)');
    ylabel('Loss Probability');
    legend({'Control Loss', 'True Loss'} )
    title(strcat("Cluster ", symbol));
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