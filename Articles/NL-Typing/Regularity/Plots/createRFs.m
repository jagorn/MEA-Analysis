function rfs = createRFs(points, r)

n = 360;
theta = (0:n-1)*(2*pi/n);


for i = 1:size(points, 1)
    x = points(i, 1) + r*cos(theta)';
    y = points(i, 2) + r*sin(theta)';
    rfs(i) = polyshape(x,y);
end

