function d = hessian_distance(p1, p2, H1, H2)

W = inv(H1 + H2);
% W = inv(diag(H1) + diag(H2));
% W = eye(4);
d = sqrt((p1 - p2) * W * (p1 - p2)');

