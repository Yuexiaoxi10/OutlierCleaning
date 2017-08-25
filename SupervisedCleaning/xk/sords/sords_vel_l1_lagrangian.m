function [y_hat, e] = sords_vel_l1_lagrangian(y, r, step, lambda)

L = length(y);
nc = length(r);
nr = L-nc-step+1;
cvx_begin quiet
cvx_solver mosek
    variables y_hat(size(y))
%     v_hat = y_hat(2:end) - y_hat(1:end-1);
    v_hat = y_hat(1+step:end) - y_hat(1:end-step);
    Hv_hat = blockHankel(v_hat, [nr, nc]);
    obj = norm(Hv_hat*r, 2) + lambda*norm(y-y_hat, 1)  ;
    minimize(obj)
cvx_end
e = y-y_hat;

end