clear
close all

% params
% class_folder = 'RGC.3.8..mat';
class_folder = 'RGC.4.4..mat';
% class_folder = 'RGC.8.8.1..mat';
% class_folder = 'RGC.8.2.4_PRUNED..mat';

nl_func = @funSigmoid;
params_0 = [0, 1, 0.1, 0.6];
params_lb = [-inf, 0, 0, 0];
params_ub = [+inf, +inf, 1, 1];

show_plots = true;
% test_non_linearities();

% fit
load(class_folder);
params_sta = fit_all_nl(non_linearities_sta, nl_x_sta, nl_func, params_0, params_lb, params_ub, show_plots);
suptitle('Non Linearities STA Method');

params_both = fit_all_nl(non_linearities_both, nl_x_both, nl_func, params_0, params_lb, params_ub, show_plots);
suptitle('Non Linearities Both Methos');

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

% plot results
figure();
confusionchart(labels, resubPredict(gaussian_classifier));
loss = resubLoss(gaussian_classifier);
title("Prediction");

% control: try to classify shuffled classes
n_trials = 100;
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

figure()
hold on
histogram(control_loss, 10, 'Normalization', 'probability', 'FaceColor', [0.7, 0.2, 0.2]);
xline(loss, 'b', 'LineWidth', 2)
xlim([-0.1, 1]);
ylim([0, 1.1]);
xlabel('Loss distribution for shuffled data');
ylabel('Loss Probability');
legend({'Control Loss', 'True Loss'} )

% plot
figure();
subplot(2, 3, 1);
hold on
plot_gauss_distrib(gaussian_params, 1, 1, 2, 'r');
plot_gauss_distrib(gaussian_params, 2, 1, 2, 'k');
k = scatter(params_sta(:, 1), params_sta(:, 2), 50, 'k', 'o', 'filled', 'MarkerFaceAlpha', .7);
r = scatter(params_both(:, 1), params_both(:, 2), 50, 'r', 'o', 'filled', 'MarkerFaceAlpha', .7);


title('Param 1 vs Param 2');
xlabel('Param 1');
ylabel('Param 2');
legend([k, r], {'STA Method', 'Both Methods'})

subplot(2, 3, 2);
hold on
plot_gauss_distrib(gaussian_params, 1, 1, 3, 'r');
plot_gauss_distrib(gaussian_params, 2, 1, 3, 'k');
scatter(params_sta(:, 1), params_sta(:, 3), 50, 'k', 'o', 'filled', 'MarkerFaceAlpha', .7);
scatter(params_both(:, 1), params_both(:, 3), 50, 'r', 'o', 'filled', 'MarkerFaceAlpha', .7);
title('Param 1 vs Param 3');
xlabel('Param 1');
ylabel('Param 3');

subplot(2, 3, 3);
hold on
plot_gauss_distrib(gaussian_params, 1, 2, 3, 'r');
plot_gauss_distrib(gaussian_params, 2, 2, 2, 'k');
scatter(params_sta(:, 2), params_sta(:, 3), 50, 'k', 'o', 'filled', 'MarkerFaceAlpha', .7);
scatter(params_both(:, 2), params_both(:, 3), 50, 'r', 'o', 'filled', 'MarkerFaceAlpha', .7);
title('Param 2 vs Param 3');
xlabel('Param 2');
ylabel('Param 3');

subplot(2, 3, 4);
hold on
plot_gauss_distrib(gaussian_params, 1, 1, 4, 'r');
plot_gauss_distrib(gaussian_params, 2, 1, 4, 'k');
scatter(params_sta(:, 1), params_sta(:, 4), 50, 'k', 'o', 'filled', 'MarkerFaceAlpha', .7);
scatter(params_both(:, 1), params_both(:, 4), 50, 'r', 'o', 'filled', 'MarkerFaceAlpha', .7);
title('Param 1 vs Param 4');
xlabel('Param 1');
ylabel('Param 4');

subplot(2, 3, 5);
hold on
plot_gauss_distrib(gaussian_params, 1, 2, 4, 'r');
plot_gauss_distrib(gaussian_params, 2, 2, 4, 'k');
scatter(params_sta(:, 2), params_sta(:, 4), 50, 'k', 'o', 'filled', 'MarkerFaceAlpha', .7);
scatter(params_both(:, 2), params_both(:, 4), 50, 'r', 'o', 'filled', 'MarkerFaceAlpha', .7);
title('Param 2 vs Param 4');
xlabel('Param 2');
ylabel('Param 4');

subplot(2, 3, 6);
hold on
plot_gauss_distrib(gaussian_params, 1, 3, 4, 'r');
plot_gauss_distrib(gaussian_params, 2, 3, 4, 'k');
scatter(params_sta(:, 3), params_sta(:, 4), 50, 'k', 'o', 'filled', 'MarkerFaceAlpha', .7);
scatter(params_both(:, 3), params_both(:, 4), 50, 'r', 'o', 'filled', 'MarkerFaceAlpha', .7);
title('Param 3 vs Param 4');
xlabel('Param 3');
ylabel('Param 4');


figure();
hold on
scatter3(params_sta(:, 1), params_sta(:, 2),  params_sta(:, 3), 50, 'k', 'filled')
scatter3(params_both(:, 1), params_both(:, 2), params_both(:, 3), 50, 'r', 'filled')
xlabel('Param 1');
ylabel('Param 2');
zlabel('Param 3');
title('all');
legend({'STA Method', 'Both Methods'})

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


function test_non_linearities()
% Test Non-Linearities
x = 1:10;

figure()
subplot(1, 3, 1)
y = funExp([0.1, 0.2, 0.3], x);
plot(x, y);
pbaspect([1 1 1])
xlim([1, 10])
ylim([-0.2, 1.2])
title('exponential');

subplot(1, 3, 2)
y = funRelu([5, 0.4, 0.3], x);
plot(x, y);
pbaspect([1 1 1])
xlim([1, 10])
ylim([-0.2, 1.2])
title('relu');

subplot(1, 3, 3)
y = funSigmoid([5, +1, 0.2, 0.2], x);
plot(x, y);
pbaspect([1 1 1])
xlim([1, 10])
ylim([-0.2, 1.2])
title('sigmoid');


suptitle('possible nonlinearities');
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