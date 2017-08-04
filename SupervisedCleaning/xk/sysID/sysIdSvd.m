function [r2Train] = sysIdSvd(y, orderUpperBound)
% function sysIdOneJoint
% system identification of trajectory of one joint

[d, n] = size(y);
if nargin < 2
    orderUpperBound = 5;
end

y = bsxfun(@minus, y, mean(y, 2));
y = y + 10;
H = blockHankel(y);
order = rankEst(H, 0.8);
order = min(order, orderUpperBound);

% order = 4;
[yh,~,r2Train] = hstln_mo(y, order);
r2Train = [r2Train; -1];
% nc = order + 1;
% H = blockHankel(yh, [n-nc+1,nc]);
% [U,S,V] = svd(H);
% r2Train = V(:,end);
% r2Train = -r2Train / r2Train(end);

% % simulate
% yHat = zeros(size(yh));
% yHat(1:order) = yh(1:order);
% for i = order+1:n
%     yHat(i) = yHat(i-order:i-1) * r2Train(1:order);
% end

% h = figure;
% plot(y, '*');
% hold on;
% plot(yh, 'o');
% % plot(yHat, 'o');
% hold off;
% close(h);

end