% AUTHOR: Jose Lopez NEU 2014
% LICENSE:This code is licensed under the BSD License.
%
% this script implements Example 2.2 in Lasserre's text.
% 
clear;clc;
%%
%form localizing matrix L
M = get_mmatrix(1,2);
L10 = localize(M,[1,0]);
L01 = localize(M,[0,1]);
[monomials,n_monomials] = get_monomials({M,L10,L01});
B = get_index_matrices(monomials,get_map(M,monomials));
C10 = get_index_matrices(monomials,get_map(L10,monomials));
C01 = get_index_matrices(monomials,get_map(L01,monomials));
%%
cvx_clear;
cvx_begin sdp
cvx_solver sedumi
cvx_precision best 

variable Q0(3,3) symmetric
variable Q1(3,3) symmetric
variable Q2(3,3) symmetric
variable Q3(3,3) symmetric

% f = x1^3 - x1^2 + 2x1x2 - x2^2 + x2^3
f_alpha = zeros(n_monomials,1);
f_alpha(get_index(monomials,[3 0])) = 1;
f_alpha(get_index(monomials,[2 0])) = -1;
f_alpha(get_index(monomials,[1 1])) = 2;
f_alpha(get_index(monomials,[0 2])) = -1;
f_alpha(get_index(monomials,[0 3])) = 1;

minimize( 0 )
subject to
Q0==0; %can set this equal to 0 to match Lasserre
Q1>=0;
Q2>=0;
Q3>=0;
for k = 1:n_monomials
    trace(Q0*B{k})+trace(Q1*C10{k})+trace(Q2*C01{k})+...
        trace(Q3*(C10{k}+C01{k}-B{k}))==f_alpha(k);
end
cvx_end
%%
syms x1 x2 real
v = [1;x1;x2];
temp = vpa(expand(v'*Q0*v + v'*Q1*v*x1 + v'*Q2*v*x2 + v'*Q3*v*(x1+x2-1)));
[coef,terms] = coeffs(temp)
coef = round(coef');
terms = terms';
[coef,terms]

% correct answer
% [  1,    x1^3]
% [  0, x1^2*x2]
% [ -1,    x1^2]
% [  0, x1*x2^2]
% [  2,   x1*x2]
% [  1,    x2^3]
% [ -1,    x2^2]