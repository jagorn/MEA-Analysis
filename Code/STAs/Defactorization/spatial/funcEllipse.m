function [x,y] = funcEllipse(p,alpha,nt)
%Plot the ellipse corresponding to one Gaussian RF, given by p

tvals = linspace(0,2*3.14,nt);

i=1;
for t=tvals
    r = sqrt(alpha/(abs((1/p(3))*(cos(t))^2 + (1/p(4))*(sin(t))^2 + p(5)*cos(t)*sin(t))));
    x(i) = p(1) + r*cos(t);
    y(i) = p(2) + r*sin(t);
    i=i+1;
end


