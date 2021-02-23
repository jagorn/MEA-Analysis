function points_transformed = transformPointsV(h, points)

[t_xs, t_ys] = transformPoints(h, points(:,1), points(:,2));
points_transformed = [t_xs(:), t_ys(:)];