% AUTHOR: Jose Lopez NEU 2014
% LICENSE:This code is licensed under the BSD License.
%
% B = GET_INDEX_MATRICES(MONOMIALS,MAP) accepts a matrix of MONOMIALS and a
% MAP matrix and returns a cell-array, B, of so-called index matrices. This
% function was made when I was trying to write dual-programs manually;
% before I found out some solvers (like SeDuMi) give you the dual answer
% when solving the primal problem. Anyway, it may still be useful so I am
% leaving it in the toolbox for now.
%
%  Example:
%  %construct moment matrix
%  M2 = get_mmatrix(2,2); 
%  %get all monomials in mmatrix
%  [monomials,~] = get_monomials(M2); 
%  %get map to optimization variables
%  map = get_map(M2,monomials); 
%  %get index matrices, B is sparse
%  B = get_index_matrices(monomials,map); 
%  B{1}
% 
% ans =
% 
%    (1,1)        1
%
function B = get_index_matrices(monomials,map)
[n_monomials,~] = size(monomials);
B(1:n_monomials,1) = {sparse(zeros(size(map)))};
for k = 1:n_monomials    
    B{k}(map(:)==k) = 1;
end
