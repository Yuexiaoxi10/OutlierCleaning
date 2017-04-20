% AUTHOR: Jose Lopez NEU 2014
% LICENSE:This code is licensed under the BSD License.
%
% This script implements Lasserre (2001) Problem 2.9
%
clear;clc;
%%
%form moment matrix
M = get_mmatrix(2,10);
[monomials,n_monomials] = get_monomials(M);
maps.M2 = get_map(M,monomials);
%form localizing matrices
%do yourself a favor and put the L's in a cell array...
M = get_mmatrix(1,10);
maps.M1 = get_map(M,monomials);
L = localize(M,[1 0 0 0 0 0 0 0 0 0]);
maps.L1000000000 = get_map(L,monomials);
L = localize(M,[0 1 0 0 0 0 0 0 0 0]);
maps.L0100000000 = get_map(L,monomials);
L = localize(M,[0 0 1 0 0 0 0 0 0 0]);
maps.L0010000000 = get_map(L,monomials);
L = localize(M,[0 0 0 1 0 0 0 0 0 0]);
maps.L0001000000 = get_map(L,monomials);
L = localize(M,[0 0 0 0 1 0 0 0 0 0]);
maps.L0000100000 = get_map(L,monomials);
L = localize(M,[0 0 0 0 0 1 0 0 0 0]);
maps.L0000010000 = get_map(L,monomials);
L = localize(M,[0 0 0 0 0 0 1 0 0 0]);
maps.L0000001000 = get_map(L,monomials);
L = localize(M,[0 0 0 0 0 0 0 1 0 0]);
maps.L0000000100 = get_map(L,monomials);
L = localize(M,[0 0 0 0 0 0 0 0 1 0]);
maps.L0000000010 = get_map(L,monomials);
L = localize(M,[0 0 0 0 0 0 0 0 0 1]);
maps.L0000000001 = get_map(L,monomials);

indices.y1100000000 = get_index(monomials,[1 1 0 0 0 0 0 0 0 0]);
indices.y0110000000 = get_index(monomials,[0 1 1 0 0 0 0 0 0 0]);
indices.y0011000000 = get_index(monomials,[0 0 1 1 0 0 0 0 0 0]);
indices.y0001100000 = get_index(monomials,[0 0 0 1 1 0 0 0 0 0]);
indices.y0000110000 = get_index(monomials,[0 0 0 0 1 1 0 0 0 0]);
indices.y0000011000 = get_index(monomials,[0 0 0 0 0 1 1 0 0 0]);
indices.y0000001100 = get_index(monomials,[0 0 0 0 0 0 1 1 0 0]);
indices.y0000000110 = get_index(monomials,[0 0 0 0 0 0 0 1 1 0]);
indices.y0000000011 = get_index(monomials,[0 0 0 0 0 0 0 0 1 1]);
indices.y1010000000 = get_index(monomials,[1 0 1 0 0 0 0 0 0 0]);
indices.y0101000000 = get_index(monomials,[0 1 0 1 0 0 0 0 0 0]);
indices.y0010100000 = get_index(monomials,[0 0 1 0 1 0 0 0 0 0]);
indices.y0001010000 = get_index(monomials,[0 0 0 1 0 1 0 0 0 0]);
indices.y0000101000 = get_index(monomials,[0 0 0 0 1 0 1 0 0 0]);
indices.y0000010100 = get_index(monomials,[0 0 0 0 0 1 0 1 0 0]);
indices.y0000001010 = get_index(monomials,[0 0 0 0 0 0 1 0 1 0]);
indices.y0000000101 = get_index(monomials,[0 0 0 0 0 0 0 1 0 1]);
indices.y1000001000 = get_index(monomials,[1 0 0 0 0 0 1 0 0 0]);
indices.y1000000010 = get_index(monomials,[1 0 0 0 0 0 0 0 1 0]);
indices.y1000000001 = get_index(monomials,[1 0 0 0 0 0 0 0 0 1]);
indices.y0100000001 = get_index(monomials,[0 1 0 0 0 0 0 0 0 1]);
indices.y0001001000 = get_index(monomials,[0 0 0 1 0 0 1 0 0 0]);
%%
cvx_clear;
cvx_begin sdp
cvx_solver sedumi;

variable y(n_monomials);

M2 = assignm(y,maps.M2);
M1 = assignm(y,get_map(M,monomials));
L1000000000 = assignm(y,maps.L1000000000);
L0100000000 = assignm(y,maps.L0100000000); 
L0010000000 = assignm(y,maps.L0010000000); 
L0001000000 = assignm(y,maps.L0001000000); 
L0000100000 = assignm(y,maps.L0000100000); 
L0000010000 = assignm(y,maps.L0000010000); 
L0000001000 = assignm(y,maps.L0000001000); 
L0000000100 = assignm(y,maps.L0000000100); 
L0000000010 = assignm(y,maps.L0000000010); 
L0000000001 = assignm(y,maps.L0000000001); 

%get aliases and form objective
% do yourself a favor and use arrays instead of individual aliases
y1100000000 = y(indices.y1100000000);
y0110000000 = y(indices.y0110000000);
y0011000000 = y(indices.y0011000000);
y0001100000 = y(indices.y0001100000);
y0000110000 = y(indices.y0000110000);
y0000011000 = y(indices.y0000011000);
y0000001100 = y(indices.y0000001100);
y0000000110 = y(indices.y0000000110);
y0000000011 = y(indices.y0000000011);
y1010000000 = y(indices.y1010000000);
y0101000000 = y(indices.y0101000000);
y0010100000 = y(indices.y0010100000);
y0001010000 = y(indices.y0001010000);
y0000101000 = y(indices.y0000101000);
y0000010100 = y(indices.y0000010100);
y0000001010 = y(indices.y0000001010);
y0000000101 = y(indices.y0000000101);
y1000001000 = y(indices.y1000001000);
y1000000010 = y(indices.y1000000010);
y1000000001 = y(indices.y1000000001);
y0100000001 = y(indices.y0100000001);
y0001001000 = y(indices.y0001001000);

obj = y1100000000+y0110000000+y0011000000+y0001100000+y0000110000+...
    y0000011000+y0000001100+y0000000110+y0000000011+...
    y1010000000+y0101000000+y0010100000+y0001010000+y0000101000+...
    y0000010100+y0000001010+y0000000101+...
    y1000001000+y1000000010+y1000000001+y0100000001+y0001001000;

maximize(obj)
subject to
y(1)==1
M2>=0
L1000000000+L0100000000+L0010000000+L0001000000+...
L0000100000+L0000010000+L0000001000+L0000000100+L0000000010+...
+L0000000001-M1==0
L1000000000>=0
L0100000000>=0
L0010000000>=0
L0001000000>=0
L0000100000>=0
L0000010000>=0
L0000001000>=0
L0000000100>=0
L0000000010>=0
L0000000001>=0
cvx_end
%(cvx_optval): +0.375

