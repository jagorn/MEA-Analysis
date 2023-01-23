function d_edge = distanceToEdge(somas, roi)

x_left = 0;
x_right = roi(1);
y_down = 0;
y_up = roi(2);

distance_left = somas(:, 1) - x_left;
distance_right = x_right - somas(:, 1);
distance_down = somas(:, 2) - y_down;
distance_up = y_up - somas(:, 2);

d_x = min(distance_left, distance_right);
d_y = min(distance_down, distance_up);

d_edge = min(d_x, d_y);
d_edge(d_edge < 0) = 0;