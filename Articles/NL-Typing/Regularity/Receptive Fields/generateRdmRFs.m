function rfs = generateRdmRFs(positions, roi, varargin)


% Parameters
gauss_parameters_lower_bound_def = [500, 500, -0.0001, 0.5];
gauss_parameters_upper_bound_def = [5000, 5000 0.0001 5];
debug_def = false;

% Parse Input
p = inputParser;
addRequired(p, 'cells');
addRequired(p, 'roi');
addParameter(p, 'Gauss_P_Lower_Bound', gauss_parameters_lower_bound_def);
addParameter(p, 'Gauss_P_Higher_Bound', gauss_parameters_upper_bound_def);
addParameter(p, 'Debug', debug_def);

parse(p, positions, roi, varargin{:});
lb = p.Results.Gauss_P_Lower_Bound;
ub = p.Results.Gauss_P_Higher_Bound;
debug = p.Results.Debug;

n_cells = size(positions, 1);
xmax = roi(1);
ymax = roi(2);

rfs = repmat(polyshape, [1, n_cells]);
for i_cell = 1:n_cells
    x0 = positions(i_cell, 1);
    y0 = positions(i_cell, 2);
    
    % Gaussian Parameters
    a = rand() * 1 * (ub(1) - lb(1)) + lb(1);
    b = rand() * 1 * (ub(2) - lb(2)) + lb(2);
    c = rand() * 1 * (ub(3) - lb(3)) + lb(3);
    A = rand() * (ub(4) - lb(4)) + lb(4);
    
    % Compute Gaussian
    % f = A * exp( -X^2/a -Y^2/b -c*XY);
    gauss_p = [a, b, c, A, x0, y0];
    
    
    % Ellipse Parameters
    ellipse_p = [x0, y0, a, b, c];
    n_vertices = 360;
    alpha = 1;
    
    % Compute Ellipse
    [ell_x, ell_y] =  funcEllipse(ellipse_p, alpha, n_vertices);
    rfs(i_cell) = polyshape(ell_x, ell_y);
    
    % Plot
    if debug
        f = funcGauss(gauss_p, [xmax, ymax]);
        figure();
        imagesc(f);
        hold on
        daspect([1 1 1]);
        plot(rfs(i_cell), 'EdgeColor', 'Red', 'LineWidth', 2);
        waitforbuttonpress();
        close();
    end
end




