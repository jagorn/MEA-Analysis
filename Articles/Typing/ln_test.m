classes = ["RGC.1.1", "RGC.3.8", "RGC.4.2", "RGC.4.4", "RGC.8.2.1", "RGC.8.2.4_PRUNED"];

i_class = 1;

class = classes(i_class);
file_mat = strcat('/home/fran_tr/Projects/MEA-Analysis/Thesis/Typing/', class, '.mat');

load(file_mat, 'non_linearities_sta', 'non_linearities_both', 'nl_x_both', 'nl_x_sta');
assert(isequal(nl_x_sta, nl_x_both));
x = nl_x_sta;

nl_sta = non_linearities_sta;
nl_both = non_linearities_both;

nl_stack = [nl_sta; nl_both];

[coeff,score,latent,tsquared,explained,mu] = pca(nl_stack);

figure
hold on
plot(x, nl_sta, 'k');
plot(x, nl_both, 'r');



% 
% params_sta = fit_all_nl(nl_sta, x, nl_func, params_0, params_lb, params_ub, show_plots);
% params_both = fit_all_nl(nl_both, x, nl_func, params_0, params_lb, params_ub, show_plots);
% 

plot(funSigmoid(params_sta(1), params_sta(2), params_sta(3), params_sta(4), x));


















function y = funSigmoid(params, x)
% PARAMETERS:
% 1) X Offset
% 2) Sigmoid Coefficient
% 3) Y Lower bound  (between 0 and 1)
% 4) Y Upper bound (between 0 and 1)

y = 1 ./ (1 + exp(-params(2) * (x - params(1))));
y = params(3) + y * (1 - params(3) - params(4));
end