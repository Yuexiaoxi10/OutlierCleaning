function [y_hat, e] = sords_l1l1_lagrangian(y, r, lambda)

L = length(y);
nc = length(r);
nr = L-nc+1;
Hy = blockHankel(y, [nr, nc]);
HyNorm = norm(Hy, 'fro');
% HyNorm = 1;
y = y / HyNorm;
cvx_begin quiet
cvx_solver mosek
    variables y_hat(size(y))
    Hy_hat = blockHankel(y_hat, [nr, nc]);
    obj =  sum((y-y_hat).^2) + lambda*sum(abs(Hy_hat*r));
    minimize(obj)
cvx_end
y = y * HyNorm;
y_hat = y_hat * HyNorm;
e = y-y_hat;

end