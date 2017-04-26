% AUTHOR: Jose Lopez NEU 2014
% LICENSE:This code is licensed under the BSD License.
%
% This script implements Lasserre Problem 2.2
%
clear;clc;
%%
Q = eye(5);
c = -[10.5,7.5,3.5,2.5,1.5]';
d = -10;
[M,basis_data] = get_mmatrix(2,6);
[monomials,n_monomials] = get_monomials(M);
maps.M2 = get_map(M,monomials);
%form localizing matrix L
M = get_mmatrix(1,6);
maps.M1 = get_map(M,monomials);
L = localize(M,[1 0 0 0 0 0]);
maps.L100000 = get_map(L,monomials);
L = localize(M,[0 1 0 0 0 0]);
maps.L010000 = get_map(L,monomials);
L = localize(M,[0 0 1 0 0 0]);
maps.L001000 = get_map(L,monomials);
L = localize(M,[0 0 0 1 0 0]);
maps.L000100 = get_map(L,monomials);
L = localize(M,[0 0 0 0 1 0]);
maps.L000010 = get_map(L,monomials);
L = localize(M,[0 0 0 0 0 1]);
maps.L000001 = get_map(L,monomials);
indices.y200000 = get_index(monomials,[2 0 0 0 0 0]);
indices.y100000 = get_index(monomials,[1 0 0 0 0 0]);
indices.y020000 = get_index(monomials,[0 2 0 0 0 0]);
indices.y010000 = get_index(monomials,[0 1 0 0 0 0]);
indices.y002000 = get_index(monomials,[0 0 2 0 0 0]);
indices.y001000 = get_index(monomials,[0 0 1 0 0 0]);
indices.y000200 = get_index(monomials,[0 0 0 2 0 0]);
indices.y000100 = get_index(monomials,[0 0 0 1 0 0]);
indices.y000020 = get_index(monomials,[0 0 0 0 2 0]);
indices.y000010 = get_index(monomials,[0 0 0 0 1 0]);
indices.y000001 = get_index(monomials,[0 0 0 0 0 1]);

%%
cvx_clear;
cvx_begin sdp
cvx_solver sedumi;

variable y(n_monomials);

M2 = assignm(y,maps.M2);
M1 = assignm(y,maps.M1);
L100000 = assignm(y,maps.L100000);
L010000 = assignm(y,maps.L010000); 
L001000 = assignm(y,maps.L001000); 
L000100 = assignm(y,maps.L000100); 
L000010 = assignm(y,maps.L000010);
L000001 = assignm(y,maps.L000001); 

%get aliases
y000000 = y(1);
y200000 = y(indices.y200000);
y100000 = y(indices.y100000);
y020000 = y(indices.y020000);
y010000 = y(indices.y010000);
y002000 = y(indices.y002000);
y001000 = y(indices.y001000);
y000200 = y(indices.y000200);
y000100 = y(indices.y000100);
y000020 = y(indices.y000020);
y000010 = y(indices.y000010);
y000001 = y(indices.y000001);


%-x1^2/2-(21*x1)/2- x2^2/2-(15*x2)/2-x3^2/2-(7*x3)/2-x4^2/2-(5*x4)/2-x5^2/2-(3*x5)/2-10*x6
minimize( -y200000/2-21*y100000/2-y020000/2-15*y010000/2-y002000/2-7*y001000/2-...
y000200-5*y000100/2-y000020/2-3*y000010/2-10*y000001 )
%minimize(c*x-0.5*x'*Q*x+d*y) %CVX complains 
subject to
y000000==1;
M2>=0;
6.5*M1-6*L100000-3*L010000-3*L001000-2*L000100-L000010>=0
20*M1-10*L100000-10*L001000-L000001>=0
L000001>=0
L100000>=0
L010000>=0
L001000>=0
L000100>=0
L000010>=0
M1-L100000>=0
M1-L010000>=0
M1-L001000>=0
M1-L000100>=0
M1-L000010>=0
cvx_end
%(cvx_optval): -213.5
