% AUTHOR: Jose Lopez NEU 2014
% LICENSE:This code is licensed under the BSD License.
%
clear;clc;

M4 = get_mmatrix(4,2);
M3 = get_mmatrix(3,2);
L40 = localize(M3,[4,0]);
L30 = localize(M3,[3,0]);
L20 = localize(M3,[2,0]);
L01 = localize(M3,[0,1]);
L10 = localize(M3,[1,0]);
[monomials,n_monomials] = get_monomials({M4,L40,L30});
n_monomials = size(monomials,1);
maps.M4 = get_map(M4,monomials);
maps.M3 = get_map(M3,monomials);
maps.L40 = get_map(L40,monomials); 
maps.L30 = get_map(L30,monomials); 
maps.L20 = get_map(L20,monomials); 
maps.L01 = get_map(L01,monomials); 
maps.L10 = get_map(L10,monomials); 

%%
%Lasserre example 4.6
cvx_clear;
cvx_begin sdp
cvx_solver sedumi;

variable y(n_monomials);

M4 = assignm(y,maps.M4);
M3 = assignm(y,maps.M3);
L40 = assignm(y,maps.L40);
L30 = assignm(y,maps.L30);
L20 = assignm(y,maps.L20);
L01 = assignm(y,maps.L01);
L10 = assignm(y,maps.L10); 

y10 = y(get_index(monomials,[1 0]));
y01 = y(get_index(monomials,[0 1]));

minimize(-y10-y01)
subject to
y(1) == 1;
M4>=0
2*L40-8*L30+8*L20+2*M3-L01>=0
4*L40-32*L30+88*L20-96*L10+36*M3-L01>=0
L10>=0
3*M3-L10>=0
L01>=0
4*M3-L01>=0
cvx_end
%answer -5.508