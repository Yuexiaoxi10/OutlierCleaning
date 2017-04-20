% AUTHOR: Jose Lopez NEU 2014
% LICENSE:This code is licensed under the BSD License.
%
% MATRIX = ASSIGNM(Y,MAP) accepts a 2D matrix AP, and a vector of 
% optimization variable, Y, and does the assignment. 
%
% Example:
%
%         %construct moment matrix
%         [M,basis_data] = get_mmatrix(2,2); 
%         %get all moments in mmatrix
%         [monomials,n_monomials] = get_monomials(M); 
%         %map to CVX variable
%         map = get_map(M,monomials); 
%         %declare CVX variables
%         variable y(n_monomials);
%         % turn M2 into a 2D matrix of optimization variables
%         M2 = assignm(y,map);
%
function matrix = assignm(y,map)
matrix = reshape(y(map(:)),size(map));

