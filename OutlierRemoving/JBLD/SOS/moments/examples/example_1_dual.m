% AUTHOR: Jose Lopez NEU 2014
% LICENSE:This code is licensed under the BSD License.
%
clear;clc;
cvx_clear;
%%
%Lasserre example 1 dual formulation
cvx_begin sdp
%cvx_solver sedumi;

M = get_mmatrix(2,2); %construct moment matrix
[monomials,~] = get_monomials(M); %get all moments in mmatrix
map = get_map(M,monomials); 
B = get_index_matrices(monomials,map); %get index matrices

variable X(6,6) symmetric;
dual variable z01;
dual variable z10;
maximize( -X(1,1) )

subject to
trace(X*B{2})==2 : z01;  %p01
trace(X*B{4})==3;  %p02
trace(X*B{7})==0;  %p03
trace(X*B{11})==1;  %p04
trace(X*B{3})==2 : z10;  %p10
trace(X*B{5})==2;  %p11
trace(X*B{8})==0;  %p12
trace(X*B{12})==0;  %p13
trace(X*B{6})==3; %p20
trace(X*B{9})==0; %p21
trace(X*B{13})==0; %p22
trace(X*B{10})==0; %p30
trace(X*B{14})==0; %p31
trace(X*B{15})==1; %p40
X>=0;
cvx_end
[z10,z01]
%cvx_optval = -0.492635 matches paper
