% AUTHOR: Jose Lopez NEU 2014
% LICENSE:This code is licensed under the BSD License.
%
% BASIS_DATA = EXPAND_BASIS(DEGREE,BASIS) accepts a (uint32) matrix
% BASIS of order-1 monomials expands it to have monomials of order 
% DEGREE. The use-case is when one would like to construct a moment 
% matrix of selected variables. For example, when one would like to 
% solve a moment problem using the running intersection property.
%
% INPUTS: DEGREE - the degree of the desired basis
%         BASIS  - a matrix of order-1 monomials
%
% Example: basis_data = expand_basis(2,eye(2,'uint32'))
%          basis_data.basis
%          ans =
%                  0           0
%                  1           0
%                  0           1
%                  2           0
%                  1           1
%                  0           2
%
function out = expand_basis(degree,basis)
basis = uint32(basis);
max_degree = mabs(basis);
n_iter = degree-max_degree;
[~,n_vars] = size(basis);
temp = find(sum(basis,2)==0);
basis(temp,:) = []; %remove zero monomial (if included) for now
out.monomial{1} = zeros(1,n_vars,'uint32'); % order-0
out.monomial{2} = basis; % order-1

%get order-2+ monomials
for i = 3:degree+1
    last_monomial = out.monomial{i-1};    
    n_monomials = size(last_monomial,1);
    % this start business is so that we don't have duplicates
    start = 1;
    for j = 1:n_vars-1
        start = [start,find(last_monomial(:,j),1,'last')+1];
    end
    temp = [];
    for k = 1:length(start)
        temp = [temp;
            last_monomial(start(k):n_monomials,:) + repmat(out.monomial{2}(k,:),n_monomials-start(k)+1,1)];
    end
    out.monomial{i} = temp;
end
out.basis = uint32(cell2mat(out.monomial(:)));
