function [y_hat, e] = sords_l1l2_lagrangian(y, r, nc, lambda1, lambda2)

L = length(y);
nr = L-nc+1;
Hy = blockHankel(y, [nr, nc]);
HyNorm = norm(Hy, 'fro');
% HyNorm = 1;
y = y / HyNorm;
cvx_begin quiet
cvx_solver gurobi_2
    variables y_hat(size(y)) e1(size(y))
    Hy_hat = blockHankel(y_hat, [nr, nc]);
    obj = norm(Hy_hat*r,2) + lambda1*norm(e1,1) + lambda2*norm(y-y_hat-e1,2);
    minimize(obj)
cvx_end
y = y * HyNorm;
y_hat = y_hat * HyNorm;
e = y-y_hat;

end