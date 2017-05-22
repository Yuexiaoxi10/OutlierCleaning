function [y_hat, e] = sords_l2(y, r, nc)

L = length(y);
nr = L-nc+1;
cvx_begin quiet
cvx_solver gurobi_2
    variables y_hat(size(y))
    Hy_hat = blockHankel(y_hat, [nr, nc]);
    Hy_hat * r == 0;
    obj = norm(y-y_hat, 2);% y = y_hat + e; e = y-y_hat; 
    minimize(obj)
cvx_end
e = y-y_hat;

end