function [omega, resTot, cnt] = outlierDetectionS2R3(y)

[d, n] = size(y);
omega = ones(1, n);

orderUpperBound = 5;
y = bsxfun(@minus, y, mean(y, 2));
H = blockHankel(y);
order = rankEst(H, 0.8);
order = min(order, orderUpperBound);
nr = order + 1;
nc = length(y) - nr + 1;
X = blockHankel(y, [d*nr, nc]);

epsilon = 3;
fix = nr;
tol = 1e-4;
step = 0;
[ropt,r,etime] = call_ssrrr_lp(X, epsilon, fix, tol, step);

resTot = abs(ropt' * X);
cnt = zeros(1, n);
for i = 1:length(resTot)
    if resTot(i) >= epsilon
        cnt(i:i+nr-1) = cnt(i:i+nr-1) + 1;
    end
end

% omega(cnt > nr-3) = 0;
omega(cnt > 1) = 0;

end