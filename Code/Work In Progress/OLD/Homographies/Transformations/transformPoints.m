function [t_xs, t_ys] = transformPoints(h, xs, ys)

hmg_points =   [xs(:)'; ys(:)'; ones(1, length(xs))];
             
t_hmg_points = h * hmg_points;
t_hmg_points = t_hmg_points ./ t_hmg_points(3,:);

t_xs = t_hmg_points(1,:);
t_ys = t_hmg_points(2,:);