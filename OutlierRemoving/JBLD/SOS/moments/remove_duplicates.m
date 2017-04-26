% AUTHOR: Jose Lopez NEU 2014
% LICENSE:This code is licensed under the BSD License.
%
% M = REMOVE_DUPLICATES(M) removes duplicate rows and columns 
% from M. This would be needed if some of the variables are 
% made 0-1. This function should not be needed outside of 
% MAKE_ZERO_ONE but you never know.
%
function M = remove_duplicates(M)
for k = 1:size(M,1)
    if(k>size(M,1)) % M is shrinking...
        break;
    end
    mon = M(k,:,1);
    [idx1,~] = ismember(M(:,:,1),mon,'rows');
    n_copies = sum(idx1);
    if(n_copies>1)
        idx2 = find(idx1,n_copies-1,'last');
        M(idx2,:,:) = [];
        M(:,:,idx2) = [];
    end
end

