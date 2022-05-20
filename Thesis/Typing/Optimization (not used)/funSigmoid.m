function y = funSigmoid(params, x)
% PARAMETERS:
% 1) X Offset
% 2) Sigmoid Coefficient
% 3) Y Lower bound  (between 0 and 1)
% 4) Y Upper bound (between 0 and 1)

y = 1 ./ (1 + exp(-params(2) * (x - params(1))));
y = params(3) + y .* (1 - params(3) - params(4));
end
