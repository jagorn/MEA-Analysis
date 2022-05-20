clear
close all

% params
% class_folder = 'RGC.3.8.mat';
% class_folder = 'RGC.4.4.mat';
class_folder = 'RGC.8.2.1.mat';
% class_folder = 'RGC.8.2.4_PRUNED.mat';

nl_func = @funSigmoid;
params_0 = [0, 1, 0.1, 0.6];
params_lb = [-inf, 0, 0, 0];
params_ub = [+inf, +inf, 1, 1];

gauss_color = [0.6, 0.2, 0.2];
pt_size = 30;

% fit
load(class_folder);
params_sta = fit_all_nl(non_linearities_sta, nl_x_sta, nl_func, params_0, params_lb, params_ub, false);
params_both = fit_all_nl(non_linearities_both, nl_x_both, nl_func, params_0, params_lb, params_ub, false);

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

% plot

subplot(3, 3, 4);
hold on
plot_gauss_distrib(gaussian_params, 2, 1, 2, 'k');
k = scatter(params_sta(:, 1), params_sta(:, 2), pt_size, 'k', 'o', 'filled', 'MarkerFaceAlpha', .7);
r = scatter(params_both(:, 1), params_both(:, 2), pt_size, 'r', 'o', 'filled', 'MarkerFaceAlpha', .7);
plot_gauss_distrib(gaussian_params, 1, 1, 2, gauss_color);
title('Offset vs Slope');
xlabel('offset');
ylabel('slope');
legend([k, r], {'STA Method', 'Both Methods'})

subplot(3, 3, 5);
hold on
plot_gauss_distrib(gaussian_params, 2, 1, 3, 'k');
scatter(params_sta(:, 1), params_sta(:, 3), pt_size, 'k', 'o', 'filled', 'MarkerFaceAlpha', .7);
scatter(params_both(:, 1), params_both(:, 3), pt_size, 'r', 'o', 'filled', 'MarkerFaceAlpha', .7);
plot_gauss_distrib(gaussian_params, 1, 1, 3, gauss_color);
title('Offset vs Lower Bound');
xlabel('offset');
ylabel('lower bound');

subplot(3, 3, 6);
hold on
plot_gauss_distrib(gaussian_params, 2, 2, 2, 'k');
scatter(params_sta(:, 2), params_sta(:, 3), pt_size, 'k', 'o', 'filled', 'MarkerFaceAlpha', .7);
scatter(params_both(:, 2), params_both(:, 3), pt_size, 'r', 'o', 'filled', 'MarkerFaceAlpha', .7);
plot_gauss_distrib(gaussian_params, 1, 2, 3, gauss_color);
title('Slope vs Lower Bound');
xlabel('slope');
ylabel('lower bound');

subplot(3, 3, 7);
hold on
plot_gauss_distrib(gaussian_params, 2, 1, 4, 'k');
scatter(params_sta(:, 1), params_sta(:, 4), pt_size, 'k', 'o', 'filled', 'MarkerFaceAlpha', .7);
scatter(params_both(:, 1), params_both(:, 4), pt_size, 'r', 'o', 'filled', 'MarkerFaceAlpha', .7);
plot_gauss_distrib(gaussian_params, 1, 1, 4, gauss_color);
title('Offset vs Upper Bound');
xlabel('offset');
ylabel('upper bound');

subplot(3, 3, 8);
hold on
plot_gauss_distrib(gaussian_params, 2, 2, 4, 'k');
scatter(params_sta(:, 2), params_sta(:, 4), pt_size, 'k', 'o', 'filled', 'MarkerFaceAlpha', .7);
scatter(params_both(:, 2), params_both(:, 4), pt_size, 'r', 'o', 'filled', 'MarkerFaceAlpha', .7);
plot_gauss_distrib(gaussian_params, 1, 2, 4, gauss_color);
title('Slope vs Upper Bound');
xlabel('slope');
ylabel('upper bound');

subplot(3, 3, 9);
hold on
plot_gauss_distrib(gaussian_params, 2, 3, 4, 'k');
scatter(params_sta(:, 3), params_sta(:, 4), pt_size, 'k', 'o', 'filled', 'MarkerFaceAlpha', .7);
scatter(params_both(:, 3), params_both(:, 4), pt_size, 'r', 'o', 'filled', 'MarkerFaceAlpha', .7);
plot_gauss_distrib(gaussian_params, 1, 3, 4, gauss_color);
title('Lower Bound vs Upper Bound');
xlabel('lower bound');
ylabel('upper bound');


function plot_gauss_distrib(gaussian_params, gaussian_idx, f1, f2, color)
Mu = gaussian_params(2*(1:2)-1,[f1 f2]); % Extract the means
Sigma = zeros(2,2,3);

Sigma(:,:,gaussian_idx) = diag(gaussian_params(2*gaussian_idx,[f1 f2])).^2; % Create diagonal covariance matrix
xlim = Mu(gaussian_idx,1) + 4*[-1 1]*sqrt(Sigma(1,1,gaussian_idx));
ylim = Mu(gaussian_idx,2) + 4*[-1 1]*sqrt(Sigma(2,2,gaussian_idx));
f = @(x,y) arrayfun(@(x0,y0) mvnpdf([x0 y0],Mu(gaussian_idx,:),Sigma(:,:,gaussian_idx)),x,y);
fcontour(f,[xlim ylim], 'LineColor', color) % Draw contours for the multivariate normal distributions
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
    x_slope = nl_x;
    
    % keep only definite values
    nl_idx_fit = ~isnan(nl);
    nl_to_fit_x = x_slope(nl_idx_fit);
    nl_to_fit_y = nl(nl_idx_fit);
    
    % fit the nl function
    [params_sing, residual] = lsqcurvefit(@funOffset, 0, nl_to_fit_x, nl_to_fit_y, -inf, +inf);
    if residual < 0.01
        params = [params_sing, 0, 0, 1-params_sing];
    else
        params = lsqcurvefit(nl_func, params_0, nl_to_fit_x, nl_to_fit_y, params_lb, params_ub);
    end
    
    % plot
    if show_plots && i_nl <= 3
        subplot(3, 3, i_nl);
        nl_y = nl_func(params, nl_x);
        hold on
        plot(nl_x, nl, 'b', 'LineWidth', 1.5);
        plot(nl_x, nl_y, 'm', 'LineWidth', 1.5);
        xline(params(1),'-.', {'Offset'});
        yline(params(3),'-.', {'Lower Bound'}, 'LabelHorizontalAlignment', 'left');
        yline(1-params(4),'-.', {'Upper Bound'}, 'LabelHorizontalAlignment', 'left');
                

        dy = gradient(nl_y, nl_x);                                      % Numerical Derivative
        [~,idx] = max(dy);                                              % Index Of Maximum
        b = [nl_x([idx-1,idx+1])' ones(2,1)] \ nl_y([idx-1,idx+1])';    % Regression Line Around Maximum Derivative
        tv = [-b(2)/b(1); (1-b(2))/b(1)];                               % Independent Variable Range For Tangent Line Plot
        f = [tv ones(2,1)] * b; 
        plot(tv, f, 'k-.');
        text(tv(1), f(1), 'Slope', 'VerticalAlignment', 'top', 'HorizontalAlignment', 'right');

        xlim([min(nl_x), max(nl_x)]);
        ylim([-0.2, 1]);
        if i_nl == 1
            legend({'Empirical', 'Func Fit'}, 'Location','northwest');
            ylabel('Probability')
            xlabel('Generator Signal');
        end
        if i_nl == 2
            title('Non-Linerarity Fit');
        end
    end
    
    params_all(i_nl, :) = params;
end
end


function y = funOffset(params, x)
% PARAMETERS:
% 1) offset
% 2) Y Offset
y =  x * 0 + params;
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