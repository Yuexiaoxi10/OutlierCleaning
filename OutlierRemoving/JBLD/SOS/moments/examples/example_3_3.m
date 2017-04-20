% AUTHOR: Jose Lopez NEU 2014
% LICENSE:This code is licensed under the BSD License.
%
% This script implements Lasserre Problem 3.3.
clear;clc;
%%
%form moment matrix
M = get_mmatrix(2,6);
[monomials,n_monomials] = get_monomials(M);
maps.M2 = get_map(M,monomials);
%form localizing matrices
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
L = localize(M,[0 0 2 0 0 0]);
maps.L002000 = get_map(L,monomials);
L = localize(M,[0 0 0 0 2 0]);
maps.L000020 = get_map(L,monomials);

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
L002000 = assignm(y,maps.L002000); 
L000020 = assignm(y,maps.L000020); 

%get aliases and form objective, all the calls to get_index should be 
%done above with the get_map's...
y200000 = y(get_index(monomials,[2 0 0 0 0 0]));
y100000 = y(get_index(monomials,[1 0 0 0 0 0]));
y020000 = y(get_index(monomials,[0 2 0 0 0 0]));
y010000 = y(get_index(monomials,[0 1 0 0 0 0]));
y002000 = y(get_index(monomials,[0 0 2 0 0 0]));
y001000 = y(get_index(monomials,[0 0 1 0 0 0]));
y000200 = y(get_index(monomials,[0 0 0 2 0 0]));
y000100 = y(get_index(monomials,[0 0 0 1 0 0]));
y000020 = y(get_index(monomials,[0 0 0 0 2 0]));
y000010 = y(get_index(monomials,[0 0 0 0 1 0]));
y000002 = y(get_index(monomials,[0 0 0 0 0 2]));
y000001 = y(get_index(monomials,[0 0 0 0 0 1]));

%syms x1 x2 x3 x4 x5 x6 real;
%expand(-25*(x1-2)^2-(x2-2)^2-(x3-1)^2-(x4-4)^2-(x5-1)^2-(x6-4)^2)
%-25*x1^2 + 100*x1 -x2^2 + 4*x2 -x3^2 + 2*x3 -x4^2 + 8*x4 -x5^2 + 2*x5 -x6^2 + 8*x6 - 138
objective = -25*y200000+100*y100000-y020000+4*y010000-y002000+2*y001000-...
y000200+8*y000100-y000020+2*y000010-y000002+8*y000001-138;
minimize(objective);

subject to
y(1)==1
M2>=0
L002000-6*L001000+L000100+5*M1>=0
L000020-6*L000010+L000001+5*M1>=0
2*M1-L100000+3*L010000>=0
2*M1+L100000-L010000>=0
6*M1-L100000-L010000>=0
L100000+L010000-2*M1>=0
L100000>=0
L010000>=0
L001000-M1>=0
5*M1-L001000>=0
L000100>=0
6*M1-L000100>=0
L000010-M1>=0
5*M1-L000010>=0
L000001>=0
10*M1-L000001>=0
cvx_end
cvx_optval
%answer: -310, M1 is rank-1, so we can read-off optimizers
M1(:,1)