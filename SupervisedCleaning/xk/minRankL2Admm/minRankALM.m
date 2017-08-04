% ALM
% minimize ||Z||_* + 0.5 * lambda * || x - d ||_2^2
% s.t. Z = mat(S*x)
% where S is Hankel operator
function x = minRankALM(data, lambda)

n = size(data, 2);
nCol = round(n/2);
nRow = n - nCol + 1;

% initialization
Y = zeros(nRow, nCol);
% Z = zeros(nRow, nCol);
% x = data';
x = zeros(size(data'));
% lambda = 1;
rho = 0.05;

% get hankel structure operator
S = formS(nRow, nCol);

maxIter = 1000;
x_pre = inf;
for i = 1:maxIter
    M = reshape(S*x, nRow, nCol);
    Z = shrinkageOperator(M+Y/rho, 1/rho);
    Temp = (Y/rho - Z);
    x = (rho*(S'*S)+lambda*eye(n)) \ (lambda*data'-rho*(S'*Temp(:)));
    temp = S * x;
    Y = Y - rho * (Z-reshape(temp, nRow, nCol));
    rho = 1.05 * rho;
    if norm(x-x_pre) < 1e-7
        break;
    end
    x_pre = x;
end
x = x';

end