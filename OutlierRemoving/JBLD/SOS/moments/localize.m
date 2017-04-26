% AUTHOR: Jose Lopez NEU 2014
% LICENSE:This code is licensed under the BSD License.
%
% L = LOCALIZE(M,MONOMIAL) makes localizing matrix by adding MONOMIAL to
% the elements of M.
% 
% Example: if we want to make an order-1 localizing matrix for the
% constraint f1(x) = 1 - x1^2 - x2^2 >=0 we would do the following
%
%       M1 = get_mmatrix(1,2);
%       L1_2 = localize(M1,[2 0]);
%       L2_2 = localize(M1,[0 2]);
%       ... do assignment 
%       then the constraint would be specified as
%       M1-L1_2-L2_2>=0
%
function L = localize(M,monomial)
n_monomials = size(M,1);
L = M;
for k = 1:n_monomials
    L(:,:,k) = bsxfun(@plus,L(:,:,k),uint32(monomial));
end


