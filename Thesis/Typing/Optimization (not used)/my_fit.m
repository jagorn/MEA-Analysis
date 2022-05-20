function [p, hessian] =  my_fit(x, y)

p_0 = [0, 1, 0.1, 0.6];
p_min = [-inf, 0, 0, 0];
p_max = [+inf, +inf, 1, 1];


opts = optimoptions('fminunc','Display','final', 'OptimalityTolerance', 10e-8);
[p, fval, exitflag, output, grad, hessian] = fminunc(@(params) my_loss(params, x, y), p_0, opts); 