function pow = SOSpow(data,order)

pow = zeros(size(data,1),order+1,size(data,2),'double');
for p = 1:size(data,2)
    pow(:,:,p) = zeros(size(data,1),order+1,'double');
    pow(:,1,p) = 1;
    for d = 1:order
        pow(:,d+1,p) = data(:,p).^d;
    end
end
pow = permute(pow,[2 3 1]);
pow = reshape(pow,[],size(pow,3))';