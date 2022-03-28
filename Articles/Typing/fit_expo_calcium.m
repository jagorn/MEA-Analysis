load('calcium_conversion.mat', 'exp_points');

x = exp_points(:, 1);
y = exp_points(:, 2);
g = fittype('a+b*exp(-c*x)');
calcium_exp = fit(x,y,g,'StartPoint',[[ones(size(x)), -exp(-x)]\y; 1]);
xx = linspace(0,5,50);
plot(x,y,'o',xx,calcium_exp(xx),'r-');

calcium_exp.a = 0;
save('calcium_conversion.mat', 'calcium_exp', '-append');