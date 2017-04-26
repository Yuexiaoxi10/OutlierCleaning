% AUTHOR: Jose Lopez NEU 2014
% LICENSE:This code is licensed under the BSD License.
%
% this script implements: 
% EXAMPLE 1 IN LASSERRE 2010, BEST L1 APPROXIMATION...
% Approximate f = x1^4 x2^2 + x1^2 x2^4 - x1^2 x2^2 + 1/27
% with a sos polynomial
%
% I made this example when I didn't know how to get the dual from the
% primal. See the joint+marginal example to see how to do it an easier way.
%
clear;clc;
%%
[M,basis_data] = get_mmatrix(3,2);
[monomials,n_monomials] = get_monomials(M); %get all moments in mmatrix
map = get_map(M,monomials); 
B = get_index_matrices(monomials,map); %get index matrices
rows = size(M(:,:,1),1); 

%%
cvx_clear
cvx_begin sdp
cvx_solver sedumi;

variable X(rows,rows) symmetric;
variable lambda(n_monomials,1);
variable g(n_monomials,1);

f = zeros(n_monomials,1);
f( get_index(monomials,[4 2;2 4; 2 2; 0 0]) ) = [1;1;-1;1/27];

minimize( sum(lambda) )
subject to
for k = 1:n_monomials
    lambda(k) + g(k) >= f(k);
    lambda(k) - g(k) >= -f(k);
    g(k)-trace(X*B{k})==0;   
end
lambda>=0;
X>=0;
cvx_end
%answer: cvx_optval = 1.6E-2, lambda = (5.445,5.367,5.367)E-3
lambda = clean(lambda,1e-6);
idx = find(lambda);
[double(monomials(idx,:)),lambda(idx)]
