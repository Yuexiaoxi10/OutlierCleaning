% AUTHOR: Jose Lopez NEU 2014
% LICENSE:This code is licensed under the BSD License.
%
% MAP = GET_MAP(MATRIX, MONOMIALS) returns a matrix, MAP, of scalars that
% correspond to an entry into a vector containing the optimization
% variables. 
%
% For example, 
%             %M2 is a 3D matrix of monomials.
%             [M2,basis_data] = get_mmatrix(2,2); 
%             %get all monomials in mmatrix
%             [monomials,n_monomials] = get_monomials(M); 
%             %map to CVX (or YALMIP or whatever!) variable
%             map = get_map(M2,monomials); 
%             %declare CVX vector
%             variable y(n_monomials); 
%             %re-assign M2, now it is 2D and will contain moments after
%             %optimization
%             M2 = assignm(y,map); 
%             
function map = get_map(matrix, monomials)
[rows,dimension,cols] = size(matrix);
m_vec = reshape(permute(matrix,[1,3,2]),[],dimension,1);
[~,idx2] = ismember(m_vec,monomials,'rows'); 
map = reshape(idx2,rows,cols);
