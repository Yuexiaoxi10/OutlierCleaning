% AUTHOR: Jose Lopez NEU 2014
% LICENSE:This code is licensed under the BSD License.
%
% This script implements Lasserre example 2, dual formulation. I made this
% before I knew how to get the dual from the primal solution. (See CVX dual
% variables and joint+marginal example.)
%
clear;clc;
%%
M = get_mmatrix(2,2); %construct moment matrix
[monomials,~] = get_monomials(M); %get all moments in mmatrix
B = get_index_matrices(monomials,get_map(M,monomials)); %get index matrices

%%
cvx_clear;
cvx_begin sdp
cvx_solver sedumi;

variable X(6,6) symmetric;
dual variables z10 z01;

maximize( -X(1,1) )

subject to
trace(X*B{2})==-4 : z01;  %p01
trace(X*B{4})==0;  %p02
trace(X*B{7})==0;  %p03
trace(X*B{11})==1;  %p04
trace(X*B{3})==-4 : z10;  %p10

trace(X*B{5})==-4;  %p11
trace(X*B{8})==0;  %p12
trace(X*B{12})==0;  %p13
trace(X*B{6})==0; %p20
trace(X*B{9})==0; %p21
trace(X*B{13})==0; %p22
trace(X*B{10})==0; %p30
trace(X*B{14})==0; %p31
trace(X*B{15})==1; %p40
X>=0;
cvx_end
%(cvx_optval): -11.4581

