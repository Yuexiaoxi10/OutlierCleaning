function [Hy_hat, S, Yt] = formHankel_colfixed(Data,nc)
yt = Data';
[dim,N] = size(yt);
point = yt(:);
nr = N - nc + 1; % rows of hankel
L = length(point); % total number of points = num(x)+num(y)
% a = [1 0];

% A = [1 zeros(1,dim*2);zeros(1,dim) 1 zeros(1,dim);...
%     zeros(1,dim*2) 1];
% A is a fixed matrix according to the dim of data and nc of hankel
A = zeros(nc,(nc-1)*dim+1);
[~,ncol] = size(A);
for i = 1 : nc
    A(i,:) = [zeros(1,(i-1)*dim) 1 zeros(1,ncol-((i-1)*dim+1))];
    
end

q = L - size(A,2);

%%
S = zeros(nc*nr*dim,L);
index = nc;
shift = 1;
for i = 1 : nr*dim
    block = (i-1)*index+1 : index*i;
    if i <= 1 
        S(block,:) = [A zeros(nc,q)];
    elseif  i > 1 && i < nr*dim
        S(block,:) = [zeros(nc,shift*(i-1)) A zeros(nc,q - shift*(i-1))];
    else
        S(block,:) = [zeros(nc,q) A];
    end
       
end
Yt = S * point;
Hy_hat = reshape(Yt,[nc,length(Yt)/nc])';
