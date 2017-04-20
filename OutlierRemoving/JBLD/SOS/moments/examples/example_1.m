% AUTHOR: Jose Lopez NEU 2014
% LICENSE:This code is licensed under the BSD License.
%
% this script implements example 1 in Lasserre's 2001 paper
%
clear;clc;
%%
% it's a good idea to do all the non CVX stuff outside of the CVX
% environment because for larger problems, especially ones that use the
% reweighted heuristic, this can save a lot of time.

[M,basis_data] = get_mmatrix(2,2); %construct moment matrix
[monomials,n_monomials] = get_monomials(M); %get all moments in mmatrix
maps.M2 = get_map(M,monomials); %map to CVX variable
indices.y40 = get_index(monomials,[4,0]);
indices.y04 = get_index(monomials,[0,4]);
indices.y20 = get_index(monomials,[2,0]);
indices.y02 = get_index(monomials,[0,2]);
indices.y11 = get_index(monomials,[1,1]);
indices.y10 = get_index(monomials,[1,0]);
indices.y01 = get_index(monomials,[0,1]);

%%
cvx_clear;
cvx_begin sdp
cvx_solver sedumi;

variable y(n_monomials); %declare CVX variables

M2 = assignm(y,maps.M2); %declare mmatrix using CVX variables

%get interpretable aliases to form objective
y00 = y(1); %y00 is always y(1)
y40 = y(indices.y40);
y04 = y(indices.y04);
y20 = y(indices.y20);
y02 = y(indices.y02);
y11 = y(indices.y11);
y10 = y(indices.y10);
y01 = y(indices.y01);

minimize(y40+y04+3*y20+3*y02+2*y11+2*y10+2*y01)
subject to
M2>=0
y00 == 1;
cvx_end
%cvx_optval = -0.492635 matches paper
%x* = (-0.2428,-0.2428)
% M2 is rank-1 so we can read off optimizers
[y10,y01] 