

lb = [-10 -10 -0.5 0.5];
up = [10 10 0.5 5];


% Gaussian Parameters
a = rand() * (up(1) - lb(1)) + lb(1);
b = rand() * (up(2) - lb(2)) + lb(2);
c = rand() * (up(3) - lb(3)) + lb(3);
A = rand() * (up(4) - lb(4)) + lb(4);

% Data points Parameters
x0 = 50;
y0 = 50;
xmax = 100;
ymax = 100;

% Compute Gaussian
% f = A * exp( -X^2/a -Y^2/b -c*XY);
gauss_p = [a, b, c, A, x0, y0];
f = funcGauss(gauss_p, [xmax, ymax]);

% Plot
figure();
imagesc(f);
hold on
daspect([1 1 1]);

% Ellipse Parameters
n_vertices = 360;
alphas = [0.1 1 10 100];

% Compute Ellipse
ellipse_p = [x0, y0, a, b, c];
for alpha = alphas
    [ell_x, ell_y] =  funcEllipse(ellipse_p, alpha, n_vertices);
    ellipse = polyshape(ell_x, ell_y);
    plot(ellipse, 'EdgeColor', 'Red', 'LineWidth', 2);
    
    % Test Gaussian Level Set
    level_set = unique(A * exp(-((ell_x-x0).^2)/a - ((ell_y-y0).^2)/b - c*(ell_x-x0).*(ell_y-y0)))
end




