function pEst = estimatePole(y, order)
% This function is to estimate the poles of a given sequence
% Input:
% y: 1-by-n vector
% order: integer scalar
% Output:
% pEst: estimated poles

Hy = hankel(y(1:order+1), y(order+1:end));
[U, S, V] = svd(Hy);
rEst = U(:, end);
pEst = roots(flipud(rEst));

end