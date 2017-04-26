% AUTHOR: Jose Lopez NEU 2014
% LICENSE:This code is licensed under the BSD License.
% 
% this script implements example 2 in Lasserre's 2001 paper
%
clear;clc;
%%
[M,basis_data] = get_mmatrix(2,2);
[monomials,n_monomials] = get_monomials(M);
maps.M2 = get_map(M,monomials);
%%
cvx_clear;
cvx_begin sdp
cvx_solver sedumi;

variable y(n_monomials);
M2 = assignm(y,maps.M2);

y00 = y(1);
y40 = y(get_index(monomials,[4,0]));
y04 = y(get_index(monomials,[0,4]));
y11 = y(get_index(monomials,[1,1]));
y10 = y(get_index(monomials,[1,0]));
y01 = y(get_index(monomials,[0,1]));

minimize(y40 - 4*y11 - 4*y10 + y04 - 4*y01)
subject to
M2>=0
y00 == 1;
cvx_end
%(cvx_optval): -11.4581 matches
%x*=(1.3247,1.3247), M2 is rank-1 so we can just read off optimizers
[y10,y01]