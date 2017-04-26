function [Ms,basis_o] = SOStrain(data,d,p,opt)
% train function for SOS outlier ditection
% data  - Nxp matrix
% d     - order of moment matrix
% p     - dimension of data
% M     - inverse moment matrix
if nargin < 4
    opt = 1;
end
assert(size(data,2) == p,'Dimension of data is different from p!')

% % % % data = normc(data')';
if 1
    [M,basis_data] = get_mmatrix(d,p);
    [monomials,~] = get_monomials(M);
    % gamma = zeros(n_monomials,1);
    gamma = get_raw_moments(data,monomials);
    map = get_map(M,monomials); 
    M = assignm(gamma,map); 
    basis_o = double(basis_data.basis);
else
    basis_data = get_monomial_basis(d,p);
    basis_o = double(basis_data.basis);
    pow = SOSpow(data,max(basis_o(:))); % pre-compute power variable
    % map to index
    basis = basis_o + 1;
    tmpadd = 0:max(basis(:)):max(basis(:))*(size(basis,2)-1);
    basis = bsxfun(@plus,basis,tmpadd);

    V = ones(size(pow,1),size(basis,1));
    for i = 1:size(basis,2)
        V = V.*pow(:,basis(:,i));
    end

    switch opt
        case 1
            M = V'*V./size(V,1);
        case 2
            M = V*V';
            M = M.*size(M,1)./trace(M);
    end
end
% % sudo inverse
% [U,S,V] = svd(M);
% diagS = diag(S);
% Spercent = cumsum(diagS)./sum(diagS);
% idx_val = min(find(Spercent > 1-1e-5)); % keep four 9 digits power
% invS = diag([1./diagS(1:idx_val); 1e10*ones(numel(diagS)-idx_val,1)]);
% M = V*invS*U';

% regularization
eps = 1e-3;
M(2:end,2:end) = M(2:end,2:end) + eps*max(trace(M(2:end,2:end)),0.01).*eye(size(M,1)-1);

Ms.M = M;
nf = trace(M(2:end,2:end))^(-1/(p+1));
[Ms.U,Ms.S,~] = svd(Ms.M.*nf);

Ms.invM = inv(M);
[Ms.invU,Ms.invS,~] = svd(Ms.invM);