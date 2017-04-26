% AUTHOR: Jose Lopez NEU 2014
% LICENSE:This code is licensed under the BSD License.
%
% This example implements Lasserre Problem 3.4 in his 2001 paper.
clear;clc;
%%
%form moment matrix
M = get_mmatrix(4,3);
[monomials,n_monomials] = get_monomials(M);
maps.M4 = get_map(M,monomials);
%form localizing matrices
M = get_mmatrix(3,3);
maps.M3 = get_map(M,monomials);
L = localize(M,[1,0,0]);
maps.L3_100 = get_map(L,monomials);
L = localize(M,[0,1,0]);
maps.L3_010 = get_map(L,monomials);
L = localize(M,[0,0,1]);
maps.L3_001 = get_map(L,monomials);
M = get_mmatrix(2,3);
maps.M2 = get_map(M,monomials);
L = localize(M,[1,0,0]);
maps.L2_100 = get_map(L,monomials);
L = localize(M,[0,1,0]);
maps.L2_010 = get_map(L,monomials);
L = localize(M,[0,0,1]);
maps.L2_001 = get_map(L,monomials);
L = localize(M,[0,0,2]);
maps.L2_002 = get_map(L,monomials);
L = localize(M,[0,1,1]);
maps.L2_011 = get_map(L,monomials);
L = localize(M,[2,0,0]);
maps.L2_200 = get_map(L,monomials);
L = localize(M,[1,1,0]);
maps.L2_110 = get_map(L,monomials);
L = localize(M,[1,0,1]);
maps.L2_101 = get_map(L,monomials);
L = localize(M,[0,2,0]);
maps.L2_020 = get_map(L,monomials);

%%
cvx_clear;
cvx_begin sdp
cvx_solver sedumi;

variable y(n_monomials);

M4 = assignm(y,maps.M4);
M3 = assignm(y,maps.M3);
L3_100 = assignm(y,maps.L3_100);
L3_010 = assignm(y,maps.L3_010);
L3_001 = assignm(y,maps.L3_001);
M2 = assignm(y,maps.M2);
L2_100 = assignm(y,maps.L2_100);
L2_010 = assignm(y,maps.L2_010);
L2_001 = assignm(y,maps.L2_001);
L2_002 = assignm(y,maps.L2_002);
L2_011 = assignm(y,maps.L2_011);
L2_200 = assignm(y,maps.L2_200);
L2_110 = assignm(y,maps.L2_110);
L2_101 = assignm(y,maps.L2_101);
L2_020 = assignm(y,maps.L2_020);

B = [0,0,1;0,-1,0;-2,1,-1];
b = [3;0;-4];
v = [0;-1;-6];
r = [1.5;-0.5;-5];

y000 = y(1);
y100 = y(get_index(monomials,[1,0,0]));
y010 = y(get_index(monomials,[0,1,0]));
y001 = y(get_index(monomials,[0,0,1]));
minimize(-2*y100+y010-y001)
subject to
y000==1
M4>=0
4*M3-L3_100-L3_010-L3_001>=0
2*M3-L3_100>=0
3*M3-L3_001>=0
6*M3-3*L3_010-L3_001>=0
L3_100>=0
L3_010>=0
L3_001>=0
4*L2_200 - 4*L2_110 + 4*L2_101 - 20*L2_100 + 2*L2_020 - 2*L2_011 +...
9*L2_010 + 2*L2_002 - 13*L2_001 + 24*M2>=0
cvx_end
%(cvx_optval): -4 matches

