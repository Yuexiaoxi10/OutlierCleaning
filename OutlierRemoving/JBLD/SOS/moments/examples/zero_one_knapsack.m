% AUTHOR: Jose Lopez NEU 2014
% LICENSE:This code is licensed under the BSD License.
%
% try a simple 0-1 problem
clear;clc;
%%
c = [2.7797,0.9439,1.8720,2.5866,3.2963]';
w = [2,6,5,1,4]';
b = 7;

M = get_mmatrix(1,5);
M = make_zero_one(M);
[monomials,n_monomials] = get_monomials(M);

%%
cvx_clear;
cvx_begin sdp
cvx_solver sedumi;

variable y(n_monomials);
M1 = assignm(y,get_map(M,monomials));

y00000 = y(1);
y10000 = y(get_index(monomials,[1,0,0,0,0]));
y01000 = y(get_index(monomials,[0,1,0,0,0]));
y00100 = y(get_index(monomials,[0,0,1,0,0]));
y00010 = y(get_index(monomials,[0,0,0,1,0]));
y00001 = y(get_index(monomials,[0,0,0,0,1]));

maximize(c(1)*y10000+c(2)*y01000+c(3)*y00100+c(4)*y00010+c(5)*y00001);
subject to
y00000==1
M1>=0
b-w(1)*y10000-w(2)*y01000-w(3)*y00100-w(4)*y00010-w(5)*y00001>=0
cvx_end
cvx_optval
x = [y10000,y01000,y00100,y00010,y00001]'
cost = w'*x
%correct answer: x = [1,0,0,1,1], cost = 7, cvx_optval = 8.6626
