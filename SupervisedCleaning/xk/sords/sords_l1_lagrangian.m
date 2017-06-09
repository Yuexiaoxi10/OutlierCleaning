function [y_hat, e] = sords_l1_lagrangian(y, r, nc, lambda)

L = length(y);
nr = L-nc+1;
Hy = blockHankel(y, [nr, nc]);
HyNorm = norm(Hy, 'fro');
% HyNorm = 1;
y = y / HyNorm;
cvx_begin quiet
cvx_solver mosek
    variables y_hat(size(y))
    Hy_hat = blockHankel(y_hat, [nr, nc]);
    obj = norm(Hy_hat*r, 2) + lambda*norm(y-y_hat, 1)  ;
    minimize(obj)
cvx_end
y = y * HyNorm;
y_hat = y_hat * HyNorm;
e = y-y_hat;

end