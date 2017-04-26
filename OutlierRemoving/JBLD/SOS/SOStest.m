function [score,V] = SOStest(data_test,M,basis,vec)

if nargin < 4
    vec = 1;
end
% data_test = normc(data_test')';
pow = SOSpow(data_test,max(basis(:))); % pre-compute power variable
Minv = M;%inv(M);
% map to index
basis = basis + 1;
tmpadd = 0:max(basis(:)):max(basis(:))*(size(basis,2)-1);
basis = bsxfun(@plus,basis,tmpadd);

V = ones(size(pow,1),size(basis,1));
for i = 1:size(basis,2)
    V = V.*pow(:,basis(:,i));
end

% score = zeros(size(pow,1),1);
% for i = 1:size(score,1)
%     score(i) = V(i,:) * Minv * V(i,:)';
% end

% Fast implementation, need to be verified with large real data
% [U,S,~] = svd(Minv);
switch vec
    case 1 
        score = sum((V*Minv.invU*sqrt(Minv.invS)).^2,2);
    case 2
        score = sum((V*Minv.invU*sqrt(Minv.invS)).^2,2);
    case 3
        score = V*Minv.invU*sqrt(Minv.invS);
    case 4
%         s = diag(Minv.S);
        score = abs(V*Minv.U(:,end));
end
