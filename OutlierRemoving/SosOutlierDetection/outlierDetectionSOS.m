function [omega, q, cnt] = outlierDetectionSOS(y, m)

[d, n] = size(y);
assert(d == 1);
omega = ones(1, n);

y = y - mean(y);
y = y / max(abs(y));

Hy = blockHankel(y, [m, n-m+1]);

nVar = size(Hy, 1);
mOrd = 2;
[basis, ~] = momentPowers(0, nVar, mOrd);
L = getInverseMomentMat(Hy', mOrd);
% [L, Minv] = getInverseMomentMat(Hy', mOrd);

thres = nchoosek(mOrd+nVar, mOrd);

n2 = size(Hy, 2);
V = zeros(size(basis, 1), n2);
for i = 1:n2
    x = Hy(:, i)';
    v = prod( bsxfun( @power, x, basis), 2);
    V(:, i) = v;
%     P(i) = v' * Minv * v;  
end
Q = L * V;
q = sum(Q.^2);

cnt = zeros(1, n);
for i = 1:length(q)
    if q(i) > thres*6
        cnt(i:i+m-1) = cnt(i:i+m-1) + 1;
    end
end

% omega(cnt > max(m-3, 0)) = 0;
omega(cnt > 0) = 0;

end