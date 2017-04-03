function y_hat = method_l2(y, r, nc)

cvx_begin quiet
variables y_hat(size(y))
Hy_hat = blockHankel(y_hat, [size(y_hat, 2)-nc+1, nc]);
Hy_hat * r == 0;
obj = norm(y-y_hat, 2);% y = y_hat + e; e = y-y_hat; 
minimize(obj)
cvx_end

end