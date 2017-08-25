function x = minRankL2Admm(y, lambda, omega)
% function minRankAdmm
% Solve the following problem with ADMM
% minimize ||Z||_* + 0.5 * lambda * || P * (x - d) ||_F^2
% s.t. Z = mat(S*x)
% where S is Hankel operator
% Inputs:
% y: d-by-n matrix, the data to fit
% lambda: scalar, penalty for infidelity of the data
% omega: 1-by-n vector, indicator of missing data, 0 if missing
% Outputs:
% x: d-by-n matrix, the fitted data

if nargin < 3
    omega = ones(1, size(y, 2));
end

[d, n] = size(y);
if d > n
    warning('dimension is larger than data length\n');
end

nCol = round(n/2);
nRow = n - nCol + 1;

% initialization
Y = zeros(d*nRow, nCol);
x = zeros(size(y'));
rho = 0.05;

% get hankel structure operator
S = formS(nRow, nCol);
StS = S' * S;

% get visible data operator
P =  formP(omega);
PtP = P' * P;

eps_abs = 1e-4;
eps_rel = 1e-4;
mu = 10;
tau = 2;
maxIter = 1000;
iter = 0;
X_pre = inf;
converge = false;
while ~converge
    X = reshape((S*x)', d*nRow, nCol);
    Z = shrinkageOperator(X-Y/rho, 1/rho);
    Temp = reshape(Z+Y/rho, d, [])';
    x = (lambda*PtP+rho*StS) \ (lambda*PtP*y'+rho*(S'*Temp));
    X = reshape((S*x)', d*nRow, nCol);
    Y = Y + rho * (Z-X);
    
    eps_pri = sqrt(n) * eps_abs + eps_rel * max(norm(X, 'fro'), norm(Z, 'fro'));
    eps_dual = sqrt(n) * eps_abs + eps_rel * norm(Y, 'fro');
    res_pri = norm(Z - X, 'fro');
    res_dual = norm(rho * (X - X_pre), 'fro');
    converge = (res_pri <= eps_pri && res_dual <= eps_dual && iter < maxIter);
    
    if res_pri > mu * res_dual
        rho = tau * rho;
    elseif res_dual > mu * res_pri
        rho = rho / tau;
    end
    X_pre = X;
end
x = x';

end