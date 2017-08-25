function [L, Minv] = getInverseMomentMat(data, mord)

regul = 1e-10;
n = size(data, 1);
nVar = size(data, 2);
[Dict,Indx] = momentPowers(0, nVar, 2*mord);
[basis,~] = momentPowers(0, nVar, mord);
Mi = getMomInd(Dict,basis,0,Indx,0);

m = zeros(1, length(Indx));
for i = 1:length(m)
    m(i) = sum( prod(bsxfun(@power, data, Dict(i,:)),2) ) / n;
end

M = m(Mi);


[~, S, V] = svd(M);
s = diag(S);
sInv = 1 ./ (s + regul);
L = diag(sInv).^0.5 * V';

if nargout > 1
    Minv = inv(M + regul * eye(size(M)));
end
% L'*L-Minv

end