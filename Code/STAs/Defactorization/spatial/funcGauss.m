function GRF = funcGauss(p, x)

[X,Y] = meshgrid(1:x(2), 1:x(1)); 
if length(x)>2
    X = X - x(3);
    Y = Y - x(4);
else
    X = X - p(5);
    Y = Y - p(6);
end

GRF = p(4) * exp(-(X.^2)/p(1) - (Y.^2)/p(2) - p(3)*X.*Y);
