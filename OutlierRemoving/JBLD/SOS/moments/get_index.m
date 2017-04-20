% AUTHOR: Jose Lopez NEU 2014
% LICENSE:This code is licensed under the BSD License.
%
% INDEX = GET_INDEX(MONOMIALS,MONOMIAL) accepts a matrix of MONOMIALS and a
% MONOMIAL (can be a matrix) and returns an INDEX into a vector. This is
% used to associate a MONOMIAL to an actual optimization variable.
%
% Example: 
%        [M,basis_data] = get_mmatrix(2,2); 
%        [monomials,n_monomials] = get_monomials(M);
%        map = get_map(M,monomials);
%        %declare CVX variable
%        variable y(n_monomials);
%        %suppose objective is f0 = x1*x2^2 and the corresponding
%        %variable...
%        y12 = y( get_index(monomials,[1 2]) );
%         
function index = get_index(monomials,monomial)
[~,index] = ismember(monomial,monomials,'rows');
