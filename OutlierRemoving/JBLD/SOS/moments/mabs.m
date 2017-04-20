% AUTHOR: Jose Lopez NEU 2014
% VALUE = MABS(X) accepts a vector or matrix, X, and returns the largest
% (absolute value) element of X. i.e. MABS(X) = MAX(ABS(X(:))).
%
function value = mabs(x)
value = max(abs(x(:)));