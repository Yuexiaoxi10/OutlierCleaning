% AUTHOR: Jose Lopez NEU 2014
% LICENSE:This code is licensed under the BSD License.
%
% [MONOMIALS, N_MONOMIALS] = GET_MONOMIALS(MATRIX) gets all of the
% monomials in MATRIX. This is intended to be used when generating a map
% between monomials and optimization variables which are usually stored in
% a vector.
%
function [monomials, n_monomials] = get_monomials(matrix)
if(iscell(matrix))
    [~,dimension,~] = size(matrix{1});
    m_vec = [];
    for k = 1:length(matrix)
        m_vec = [m_vec;reshape(permute(matrix{k},[1,3,2]),[],dimension,1)];
    end
else
    [~,dimension,~] = size(matrix);
    m_vec = reshape(permute(matrix,[1,3,2]),[],dimension,1);
end
[monomials,~,~] = unique(m_vec,'rows'); 
temp = sortrows([monomials,sum(monomials,2)],dimension+1);
monomials = temp(:,1:dimension);
[n_monomials,~] = size(monomials);
