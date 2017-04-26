function H = hankel_rowfixed(X, rownum)
% make a row fixed hankel matrix

[dim, N] = size(X);

nr = rownum;
nc = N - nr + 1;

H = [];

for j = 1 : nc
    H(:,j) = reshape(X(:,j:nr+j-1),dim*nr,1);
end


end
