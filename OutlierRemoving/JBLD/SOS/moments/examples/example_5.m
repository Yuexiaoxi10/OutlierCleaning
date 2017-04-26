% AUTHOR: Jose Lopez NEU 2014
% LICENSE:This code is licensed under the BSD License.
%
% This example implements Lasserre example 5.
%
clear;clc;
%%
M = get_mmatrix(2,2);
[monomials,n_monomials] = get_monomials(M);
maps.M2 = get_map(M,monomials);
%get localizing matrix
M = get_mmatrix(1,2);
maps.M1 = get_map(M,monomials);
L = localize(M,[1,0]);
maps.L10 = get_map(L,monomials);
L = localize(M,[0,1]);
maps.L01 = get_map(L,monomials);
L = localize(M,[2,0]);
maps.L20 = get_map(L,monomials);
L = localize(M,[1,1]);
maps.L11 = get_map(L,monomials);
L = localize(M,[0,2]);
maps.L02 = get_map(L,monomials);

%%
cvx_clear;
cvx_begin sdp
cvx_solver sedumi;

variable y(n_monomials);
M2 = assignm(y,maps.M2);
M1 = assignm(y,maps.M1);
L10 = assignm(y,maps.L10);
L01 = assignm(y,maps.L01);
L20 = assignm(y,maps.L20);
L11 = assignm(y,maps.L11);
L02 = assignm(y,maps.L02);

y00 = y(1);
y01 = y(get_index(monomials,[0,1]));
y10 = y(get_index(monomials,[1,0]));
y11 = y(get_index(monomials,[1,1]));
y20 = y(get_index(monomials,[2,0]));
y02 = y(get_index(monomials,[0,2]));

minimize(-2*y20 + 2*y11 + 2*y10 - 2*y02 + 6*y01)
subject to
M2>=0;
-L20+2*L10>=0;
-L20+2*L11-L02+M1>=0;
-L02+6*L01-8*M1>=0;
y00 == 1;
cvx_end
[y10,y01]
%(cvx_optval): 8 true optimal = 8
