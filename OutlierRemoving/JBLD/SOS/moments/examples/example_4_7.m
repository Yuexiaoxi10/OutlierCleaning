% AUTHOR: Jose Lopez NEU 2014
% LICENSE:This code is licensed under the BSD License.
%
% This example implements Lasserre problem 4.7 in his 2001 paper.
%
clear;clc;
%%
M = get_mmatrix(5,2);
[monomials,n_monomials] = get_monomials(M);
maps.M5 = get_map(M,monomials)

%form localizing matrices
M = get_mmatrix(2,2);
maps.M2 = get_map(M,monomials);
L = localize(M,[4,0]);
maps.L2_40 = get_map(L,monomials);
L = localize(M,[0,1]);
maps.L2_01 = get_map(L,monomials);
M = get_mmatrix(1,2);
maps.M1 = get_map(M,monomials);
L = localize(M,[1,0]);
maps.L1_10 = get_map(L,monomials);
L = localize(M,[0,1]);
maps.L1_01 = get_map(L,monomials);
indices.y10 = get_index(monomials,[1,0]);
indices.y01 = get_index(monomials,[0,1]);
indices.y02 = get_index(monomials,[0,2]);
indices.y40 = get_index(monomials,[4,0]);
%%
cvx_clear;
cvx_begin sdp
cvx_solver sedumi;

variable y(n_monomials);
M5 = assignm(y,maps.M5);

M2 = assignm(y,maps.M2);
L2_40 = assignm(y,maps.L2_40);
L2_01 = assignm(y,maps.L2_01);
M1 = assignm(y,maps.M1);
L1_10 = assignm(y,maps.L1_10);
L1_01 = assignm(y,maps.L1_01);

y00 = y(1);
y10 = y(indices.y10);
y01 = y(indices.y01);
y02 = y(indices.y02);
y40 = y(indices.y40);

minimize(-12*y10-7*y01+y02)
subject to
y00==1
M5>=0
-2*L2_40+2*M2-L2_01==0
L1_10>=0
2*M1-L1_10>=0
L1_01>=0
3*M1-L1_01>=0
cvx_end

[y10,y01] %M1 is rank-1
%(cvx_optval): -16.7389 matches
%x* = (0.71756,1.4698)
