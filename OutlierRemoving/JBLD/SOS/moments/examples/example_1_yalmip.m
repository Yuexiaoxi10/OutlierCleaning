% AUTHOR: Jose Lopez NEU 2014
% LICENSE:This code is licensed under the BSD License.
%
% this script implements Lasserre's example 1 using yalmip
%
clear;clc;
yalmip('clear');
%%

[M,basis_data] = get_mmatrix(2,2); %construct moment matrix
[monomials,n_monomials] = get_monomials(M); %get all moments in mmatrix
map = get_map(M,monomials); %get map to yalmip variables

y = sdpvar(n_monomials,1); %declare variables
M2 = assignm(y,map); %declare mmatrix using variables

%get interpretable aliases to form objective
y00 = y(1); %y00 is always y(1)
y40 = y(get_index(monomials,[4,0]));
y04 = y(get_index(monomials,[0,4]));
y20 = y(get_index(monomials,[2,0]));
y02 = y(get_index(monomials,[0,2]));
y11 = y(get_index(monomials,[1,1]));
y10 = y(get_index(monomials,[1,0]));
y01 = y(get_index(monomials,[0,1]));

objective = y40+y04+3*y20+3*y02+2*y11+2*y10+2*y01;
constraints = [M2>=0,y00==1];
%options = sdpsettings('solver','sdpa');
solvesdp(constraints,objective,[]);
double(objective) %-0.49263 
%M2 is rank-1 so we can read off optimizers
double([y10,y01]) %-0.24284     -0.24284
