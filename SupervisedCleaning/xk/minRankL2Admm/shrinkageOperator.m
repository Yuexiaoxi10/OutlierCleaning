function X_out = shrinkageOperator(X, tau)

[U,S,V] = svd(X);
s = diag(S);
s = s - tau;
s(s < 0) = 0;
I = eye(size(S));
S(I==1) = s;
X_out = U * S * V';

end