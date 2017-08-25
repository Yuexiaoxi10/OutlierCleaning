function [omega, x] = outlierDetectionPropagation(y, r, thres)

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

% model based
x = y;
assert(x(1:m)*r < thres);
for i = m+1:n
    if abs(x(i-m+1:i)*r) > thres
        omega(i) = 0;
        x(i) = x(i-m+1:i-1) * r(1:end-1);
    end
end

% % HSTLN based
% x = y;
% assert(x(1:m)*r < thres);
% for i = m+1:n
%     if abs(x(i-m+1:i)*r) > thres
%         omega(i) = 0;
%         om = ones(1, i);
%         om(end) = 0;
% %         xm = mean(x(1:i));
%         xHat = hstln_mo(x(1:i), m, [], om);
% %         xHat = xHat + xm;
%         x(i) = xHat(end);
%     end
% end

end