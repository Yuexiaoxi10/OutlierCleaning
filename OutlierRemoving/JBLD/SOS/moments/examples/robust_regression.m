% AUTHOR: Jose Lopez NEU 2015
% LICENSE:This code is licensed under the BSD License.
%
% This "robust regression" example shows how to use the running 
% intersection property and the reweighted heuristic to get a rank-1 
% solution.
%
% objective:                 max_(s,r) f0 = sum( s ) 
%                 subject to
%                            si(r'xi)=0
%                            si^2 = si
%

clear;clc;

%%
% the data comes from the line: x2 = 1.7*x1 (+ 1 outlier)
% r = [-0.8619;0.5070] = nullspace of data' without outlier
% last column of data is the outlier: 
data = [-2 -1 0 1 2 3;
    -3.4 -1.7 0 1.7 3.4 1]; 

% r'*data = [0 0 0 0 0 -2.07878251890991]
n_points = size(data,2); 

%%
n_vars = n_points + 2; % selector variables + r
relaxation = 1;
[M,basis_data] = get_mmatrix(relaxation,n_vars); 
mons1 = basis_data.monomial{2}; %first order monomials
s_mons = mons1(1:n_points,:);   %these are the monomials for s and r
r_mons = mons1(n_points+1:end,:);

% since we want to use running intersection property we need 
% n_points moment matrices for si*r terms
M = cell(n_points,1);
for k = 1:n_points
    temp = [zeros(1,n_vars); s_mons(k,:); r_mons]; %monomials in each 4x4 matrix
    M{k} = get_mmatrix(relaxation,n_vars,temp);
    M{k} = make_zero_one(M{k}, s_mons(k,:)); % make si 0-1
end

% get all the monomials in our problem
[monomials, n_monomials] = get_monomials(M);

% get maps to our decision vector for use in CVX (or YALMIP)
% we generally want to do this outside the reweighting loop
indices.s = get_index(monomials,s_mons);
indices.r = get_index(monomials,r_mons);
indices.r1_2 = get_index(monomials,r_mons(1,:)+r_mons(1,:));
indices.r2_2 = get_index(monomials,r_mons(2,:)+r_mons(2,:));

maps.M = cell(n_points,1);
for k = 1:n_points
    maps.M{k} = get_map(M{k},monomials);
    indices.si_r1(k,1) = get_index(monomials, s_mons(k,:) + r_mons(1,:));
    indices.si_r2(k,1) = get_index(monomials, s_mons(k,:) + r_mons(2,:));
end

% setup reweighting stuff
% spoiler alert: it takes 57 iterations

I = eye(4);
W = cell(n_points,1);
%first run, no reweighted heuristic
W(:) = {zeros(4)};
iteration = 1;
flag = 1;

%%
while ( flag )
cvx_clear;
cvx_begin sdp;
cvx_solver sedumi;

variable y(n_monomials,1); 

s = y(indices.s);
r = y(indices.r);

si_r1 = y(indices.si_r1);
si_r2 = y(indices.si_r2);
r1_2 = y(indices.r1_2);
r2_2 = y(indices.r2_2);

M1 = cell(n_points,1);
f1 = 0;
% yes, there are a lot of for loops but these are just assignments...
for k = 1:n_points
    M1{k} = assignm(y,maps.M{k});
    f1 = f1 + trace(W{k}*M1{k});
end
f0 = sum(s);

maximize( f0 - f1 )
subject to
y(1)==1;
r1_2 + r2_2 == 1; 
for k = 1:n_points
    M1{k}>=0;
    si_r1(k)*data(1,k) + si_r2(k)*data(2,k) == 0;
end

cvx_end

rank1_test = zeros(1,n_points); 
temp = zeros(4,n_points); % the SVDs of the moment matrices
for k = 1:n_points
    temp(:,k) = svd(full(M1{k}));
    rank1_test(k) = temp(2,k);
    W{k} = inv( M1{k} + I*temp(2,k) );
end
flag = any( rank1_test > 1e-4); % stop when all are rank-1
iteration = iteration + 1;
fprintf('ITERATION: %d\n',iteration);
temp
end
fprintf('Rank-1 solution found!\n');
% r = [-0.861934215157769;0.507020126563394] = nullspace of data'
s
r
