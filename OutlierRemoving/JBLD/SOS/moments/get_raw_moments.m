% AUTHOR: Jose Lopez NEU 2014
% LICENSE:This code is licensed under the BSD License.
%
% VALUE = GET_RAW_MOMENTS(DATA, MONOMIALS) estimates the raw moments of
% DATA for the specified moment MONOMIALS. 
% 
% Example:
%           X = rand(10000,1);
%           mons = (0:4)';
%           gamma = get_raw_moments(X,mons);
%           gives gamma = 1 0.50044 0.33418 0.25084 0.2007
%           which is close to the true moments for U[0,1]
%           of 1 1/2 1/3 1/4 1/5
%
function value = get_raw_moments(data, monomials)
[n_monomials,n_vars] = size(monomials);
value = zeros(n_monomials,1);

% COMPUTE POWERS (ONLY ONCE)
max_deg = max(monomials(:));
% lookup = cell(max_deg+1,1);
% lookup{1} = ones(size(data));
% lookup{2} = data;
lookup = zeros(size(data,1),size(data,2),max_deg+1);
lookup(:,:,1) = ones(size(data));
lookup(:,:,2) = data;
for k = 3:max_deg+1
%     lookup{k} = lookup{k-1}.*data;
    lookup(:,:,k) = lookup(:,:,k-1).*data;
end

% COMPUTE MOMENTS USING LOOKUP
temp_monos = zeros(size(data,1),n_monomials);

for k = 1:n_monomials
%     temp = lookup{monomials(k,1) + 1}(:,1);
    temp = lookup(:,1,monomials(k,1)+1);
    for j = 2:n_vars
        if monomials(k,j)==0
            continue;
        end
%         temp = temp.*lookup{monomials(k,j) + 1}(:,j);
        temp = temp.*lookup(:,j,monomials(k,j)+1);
    end
    temp_monos(:,k) = temp;
%     value(k) = mean(temp);
end
value = mean(temp_monos);