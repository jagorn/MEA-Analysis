function P = createCircle(xc, yc, r)
n = 360;
theta = (0:n-1)*(2*pi/n);
x = xc + r*cos(theta);
y = yc + r*sin(theta);
P = polyshape(x,y);
