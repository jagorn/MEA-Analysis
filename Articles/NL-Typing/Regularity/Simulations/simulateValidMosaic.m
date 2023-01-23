function points = simulateValidMosaic(roi_length, r, n, xy_std, do_plot)

% params
% roi_length = 500;
% r = 60;
% xy_std = 10;
% n = 9;
% do_plot = true;

% variables
roi = [0, 0, roi_length, roi_length];
roi_max = [roi(1) - 5*r, roi(2) - 5*r, roi(3) + 5*r, roi(4) + 5*r];
roi_center = [(roi(3)-roi(1))/2, (roi(4)-roi(2))/2];
x0 = rand() * r + roi_max(1);
y0 = rand() * r + roi_max(2);
theta = rand() * pi;
d = 2*r;

R = [cos(theta) -sin(theta) 0; ...
    sin(theta)  cos(theta) 0; ...
    0           0  1];

% initialization
y = y0;
x = x0;
i_y = 0;
i_x = 0;

% compute all points
points = zeros(0, 2);
i_point = 0;
while y < roi_max(4)
    y = y0 + i_y * d * sqrt(3) / 2;
    
    if y < roi_max(4)
        i_x = 0;
        x = 0;
        
        while x < roi_max(3)
            x = x0 + i_x * d + d / 2 * mod(i_y, 2);
            
            if x < roi_max(3)
                i_point = i_point + 1;
                points(i_point, :) = [x + normrnd(0, xy_std), y + normrnd(0, xy_std)];
                i_x = i_x + 1;
            end
        end
        
        i_y = i_y + 1;
    end
end
n_points = size(points, 1);

% rotate all points
points_inhom = [points'; ones(1, n_points)];
center = repmat([roi_center 1]', 1, n_points);
points_rotated_inhom = R*(points_inhom-center) + center;
points = points_rotated_inhom(1:2, :)';

% crop all points
crop_idx = points(:, 1) > roi(1) & points(:, 1) < roi(3) & points(:, 2) > roi(2) & points(:, 2) < roi(4);
points = points(crop_idx, :);
n_points = size(points, 1);

% sample points
all_points = points;
n_all_points = size(all_points, 1);

if n_points < n
    warning("not enough cells can be sampled with these parameters");
    points = nan(n, 2);
    return 
end
if n <= 0
        sampling_idx = 1:n_points;
else
    sampling_idx = randperm(n_points, n);
    points = points(sampling_idx, :);
    n_points = size(points, 1);
end

% plot
if do_plot
    figure();
    daspect([1 1 1]);
    hold on;
    rectangle('Position', [roi_max(1), roi_max(2), roi_max(3)-roi_max(1), roi_max(4)-roi_max(2)]);
    rectangle('Position', [roi(1), roi(2), roi(3)-roi(1), roi(4)-roi(2)]);
    
    viscircles(all_points, ones(1, n_all_points) * d/2', 'Color', 'Black');
    scatter(all_points(:, 1), all_points(:, 2), 30, [0.1, 0.1, 0.1], 'Filled');
    
    viscircles(all_points(sampling_idx, :), ones(1, numel(sampling_idx)) * d/2', 'Color', 'Red');
    scatter(all_points(sampling_idx, 1), all_points(sampling_idx, 2), 30, [0.8, 0.2, 0.2], 'Filled');
end