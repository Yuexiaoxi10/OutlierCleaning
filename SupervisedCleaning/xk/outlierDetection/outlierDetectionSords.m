function [omega, resTot, cnt] = outlierDetectionSords(y, r, thres)

if nargin < 3
    thres = 1e-6;
end

assert(iscolumn(r));

[d, n] = size(y);
omega = ones(1, n);
m = length(r);

Hy = blockHankel(y, [d*(n-m+1), m]);
res = Hy * r;
res = reshape(res, [d, n-m+1]);
resTot = sqrt(sum(res.^2, 1));

cnt = zeros(1, n);
for i = 1:length(resTot)
    if resTot(i) > thres
        cnt(i:i+m-1) = cnt(i:i+m-1) + 1;
    end
end

omega(cnt > max(m-3, 0)) = 0;
% omega(cnt > 0) = 0;

end