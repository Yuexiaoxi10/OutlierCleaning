% AUTHOR: Jose Lopez NEU 2014
% LICENSE:This code is licensed under the BSD License.
%
% M = MAKE_ZERO_ONE(M, VARARGIN) sets up a moment matrix for a 0-1 program by
% changing some/all the powers (of variables specified in VARARGIN{1}) larger
% than 1 to 1 and removing duplicate rows and columns, VARARGIN{1}=1.
%
% VARARGIN can be empty or a column matrix of first order monomials to be
% made 0-1.
%
% Example: M = get_mmatrix(2,2);
%          %make variable with monomial [1 0] be 0-1. i.e. if x is the
%          %corresponding variable, then x^2=x will be enforced in M.
%          M = make_zero_one(M,[1 0]);
%
function M = make_zero_one(M,varargin)
rm_duplicates = 1;
if( isempty(varargin) )
    M(M>1) = 1;
else
    n_args = length(varargin);
    basis = varargin{1};
    if(n_args==2)
        rm_duplicates = varargin{2};
    end
    temp = cast(basis,'uint32');
    n_mons = size(temp,1);
    for j = 1:n_mons
        mon = temp(j,:);
        idx = find(mon,1);
        for k = 1:size(M,3)
            M( M(:,idx,k)>0, idx, k ) = 1;
        end
    end
end
if(rm_duplicates)
    M = remove_duplicates(M);
end