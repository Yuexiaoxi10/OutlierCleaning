% AUTHOR: Jose Lopez NEU 2014
% LICENSE:This code is licensed under the BSD License.
%
% This example implements Lasserre example 3, dual formulation. I made this
% before I knew how to get the dual from the primal..
%
clear;clc;

%%
M = get_mmatrix(3,2);
[monomials,n_monomials] = get_monomials(M);
map = get_map(M,monomials);
B = get_index_matrices(monomials,map); %get index matrices
M = get_mmatrix(2,2);
L20 = localize(M,[2,0]);
L02 = localize(M,[0,2]);
%form localizing matrix L
C = get_index_matrices(monomials,get_map(M,monomials));
C20 = get_index_matrices(monomials,get_map(L20,monomials));
C02 = get_index_matrices(monomials,get_map(L02,monomials));

%%
cvx_clear;
cvx_begin sdp
cvx_solver sedumi;

a = 1;
pa = zeros(28,1);
idx = get_index(monomials,[4 2; 2 4; 2 2]);
pa(idx(1:2)) = 1;
pa(idx(3)) = -1;

variable X(10,10) symmetric;
variable Z(6,6) symmetric;
dual variables z{n_monomials-1};

%form objective 
maximize( -X(1,1)-a^2*Z(1,1) )
subject to
X>=0;
Z>=0;
for k = 2:n_monomials
    trace(X*B{k})+trace(Z*(a*C{k}-C20{k}-C02{k}))==pa(k) : z{k-1};
end
cvx_end
%(cvx_optval): -0.037037 matches


