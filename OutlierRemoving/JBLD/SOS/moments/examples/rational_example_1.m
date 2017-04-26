% AUTHOR: Jose Lopez NEU 2014
% LICENSE:This code is licensed under the BSD License.
% 
% This example implements an example of optimizing rational functions.
%
% minimize f(x) = (x+1)/(x+10) on [0,1] using method from
% Lasserre 2009: Moments and sos for polynomial optzn and related problems
% PRIMAL METHOD (3.2)
%
clear;clc;
close all;
%%
[M,basis_data] = get_mmatrix(2,1); 
[monomials,n_monomials] = get_monomials(M);

%%
cvx_clear
cvx_begin sdp
cvx_solver sedumi

variable y(n_monomials,1);
[M,basis_data] = get_mmatrix(1,1); 
M1 = assignm(y,get_map(M,monomials));
L = localize(M,1);
L1 = assignm(y,get_map(L,monomials));

y0 = y(1);
y1 = y(2);

minimize( y1 + y0)
subject to
M1>=0
L1>=0
M1-L1>=0
y1+10*y0==1
cvx_end
% cvx_optval = 0.1 as expected
% warm fuzzies: t = linspace(0,1,1000);f = (t+1)./(t+10);min(f) %=0.1

%%
% DUAL METHOD (3.5). I made this example before I knew Sedumi also computes
% the dual solution when solving the primal.
%
[M,~] = get_mmatrix(2,1); 
[monomials,n_monomials] = get_monomials(M);
[M,basis_data] = get_mmatrix(1,1); 
B = get_index_matrices(monomials,get_map(M,monomials));
C = get_index_matrices(monomials,get_map(localize(M,1),monomials));
%%
cvx_clear
cvx_begin sdp
cvx_solver sedumi

variable lambda;
variable X1(2,2) symmetric;
variable X2(2,2) symmetric;
variable X3(2,2) symmetric;

%(y1 + y0) / (y1 + 10*y0)
%p0 = 1, p1 = 1 p2 = 0 q0 = 10 q1 = 1 q2 = 0
p = [1,1,0,0,0];
q = [10,1,0,0,0];

maximize( lambda )
subject to
for k = 1:n_monomials
    p(k) - lambda*q(k) == trace(X1*B{k}) + trace(X2*C{k}) + trace(X3*(B{k}-C{k}));
end
X1>=0;
X2>=0;
X3>=0;
cvx_end
% cvx_optval = 0.1 as expected!
