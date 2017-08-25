function [y_hat, e] = sords_l1_lagrangian_md(y, r, lambda, omega)

if nargin < 4
    omega = ones(1, size(y, 2));
end

[d, L] = size(y);
omega = repmat(omega, d, 1);
nc = length(r);
nr = L-nc+1;
Hy = blockHankel(y, [d*nr, nc]);
HyNorm = norm(Hy, 'fro');
% HyNorm = 1;
y = y / HyNorm;
cvx_begin quiet
cvx_solver mosek
    variables y_hat(d, L)
    Hy_hat = blockHankel(y_hat, [d*nr, nc]);
%     obj = sum(max(abs(omega.*(y-y_hat)))) + lambda/2*sum((Hy_hat*r).^2);
    obj = sum(norms(omega.*(y-y_hat),2,1)) + lambda/2*sum((Hy_hat*r).^2);
    minimize(obj)
cvx_end
y = y * HyNorm;
y_hat = y_hat * HyNorm;
e = y-y_hat;

end