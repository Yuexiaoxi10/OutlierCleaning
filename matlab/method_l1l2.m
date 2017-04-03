function y_hat = method_l1l2(y, r, nc, lambda)

% lambda = 1000;
cvx_begin quiet
cvx_solver gurobi_2
    variables y_hat(size(y)) outlier_hat(size(y)) noise_hat(size(y))
    Hy_hat = formHankel_colfixed(y_hat',nc);
    % obj = norm_nuc([Hy Hy_hat]);
    Hy_hat * r == 0;
    y-y_hat-outlier_hat-noise_hat == 0;
    obj = sum(sum(abs(outlier_hat),2)) + lambda*(sum(sum(noise_hat.*noise_hat)));
    minimize(obj)
cvx_end

end