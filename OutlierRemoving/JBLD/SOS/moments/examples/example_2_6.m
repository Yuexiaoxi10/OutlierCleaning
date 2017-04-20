% AUTHOR: Jose Lopez NEU 2014
% LICENSE:This code is licensed under the BSD License.
%
% This script implements Lasserre (2001) Problem 2.6
%
clear;clc;
%%
[M,basis_data] = get_mmatrix(2,10);
[monomials,n_monomials] = get_monomials(M);
maps.M2 = get_map(M,monomials);
%form localizing matrix L
M = get_mmatrix(1,10);
maps.M1 = get_map(M,monomials);
mons = basis_data.monomial{2}; %first order monomials
maps.L = cell(10,1);
for k = 1:10
    L = localize(M,mons(k,:));
    maps.L{k} = get_map(L,monomials);
end
indices.x = get_index(monomials,mons);
indices.x2 = get_index(monomials,mons+mons);

%%
cvx_clear;
cvx_begin sdp
cvx_solver sedumi;

variable y(n_monomials);
M2 = assignm(y,maps.M2);
M1 = assignm(y,maps.M1);

L = cell(10,1);
for k = 1:10
    L{k} = assignm(y,maps.L{k});
end

x1 = y(indices.x(1));
x2 = y(indices.x(2));
x3 = y(indices.x(3));
x4 = y(indices.x(4));
x5 = y(indices.x(5)); 
x6 = y(indices.x(6)); 
x7 = y(indices.x(7));
x8 = y(indices.x(8)); 
x9 = y(indices.x(9)); 
x10 = y(indices.x(10)); 
x1_2 = y(indices.x2(1));
x2_2 = y(indices.x2(2)); 
x3_2 = y(indices.x2(3)); 
x4_2 = y(indices.x2(4)); 
x5_2 = y(indices.x2(5)); 
x6_2 = y(indices.x2(6)); 
x7_2 = y(indices.x2(7)); 
x8_2 = y(indices.x2(8)); 
x9_2 = y(indices.x2(9)); 
x10_2 = y(indices.x2(10));

objective = -50*x1_2+48*x1-50*x2_2+42*x2-50*x3_2+48*x3-50*x4_2+45*x4-50*x5_2+44*x5-...
50*x6_2+41*x6-50*x7_2+47*x7-50*x8_2+42*x8-50*x9_2+45*x9-50*x10_2+46*x10;

minimize(objective)
subject to
y(1)==1;
M2>=0;
for k = 1:10
    L{k}>=0;
    M1 - L{k}>=0;
end
-4*M1-(-2*L{1}-6*L{2}-L{3}-3*L{5}-3*L{6}-2*L{7}-6*L{8}-2*L{9}-2*L{10})>=0;
22*M1-(6*L{1}-5*L{2}+8*L{3}-3*L{4}+L{6}+3*L{7}+8*L{8}+9*L{9}-3*L{10})>=0;
-6*M1-(6*L{2}-5*L{1}+5*L{3}+3*L{4}+8*L{5}-8*L{6}+9*L{7}+2*L{8}-9*L{10})>=0;
-23*M1-(9*L{1}+5*L{2}-9*L{4}+L{5}-8*L{6}+3*L{7}-9*L{8}-9*L{9}-3*L{10})>=0;
-12*M1-(7*L{2}-8*L{1}-4*L{3}-5*L{4}-9*L{5}+L{6}-7*L{7}-L{8}+3*L{9}-2*L{10})>=0;
cvx_end
%(cvx_optval): -39, M1 is rank-1 so we can read off optimizers
%x* = (1001110111)
y(indices.x)