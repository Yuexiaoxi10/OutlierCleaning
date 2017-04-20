% AUTHOR: Jose Lopez NEU 2014
% LICENSE:This code is licensed under the BSD License.
%
% This script implements Lasserre 2001 example 3
clear;clc;
M = get_mmatrix(3,2);
[monomials,n_monomials] = get_monomials(M);
maps.M3 = get_map(M,monomials);
%form localizing matrix L
M = get_mmatrix(2,2);
maps.M2 = get_map(M,monomials);
L = localize(M,[2,0]);
maps.L20 = get_map(L,monomials);
L = localize(M,[0,2]);
maps.L02 = get_map(L,monomials);
indices.y42 = get_index(monomials,[4,2]);
indices.y24 = get_index(monomials,[2,4]);
indices.y22 = get_index(monomials,[2,2]);
indices.y20 = get_index(monomials,[2,0]);
indices.y02 = get_index(monomials,[0,2]);
%%
cvx_clear;
cvx_begin sdp
cvx_solver sedumi;

variable y(n_monomials);

M3 = assignm(y,maps.M3);
M2 = assignm(y,maps.M2);
L20 = assignm(y,maps.L20);
L02 = assignm(y,maps.L02);

a = 1;
L = a*M2-L20-L02;

%form objective 
y00 = y(1);
y42 = y(indices.y42);
y24 = y(indices.y24);
y22 = y(indices.y22);
y20 = y(indices.y20);
y02 = y(indices.y02);
minimize(y42+y24-y22)
subject to
M3>=0
L>=0
y00 == 1;
cvx_end
%(cvx_optval): -0.037037 matches

