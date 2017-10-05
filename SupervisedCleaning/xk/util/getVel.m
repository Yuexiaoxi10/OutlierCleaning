function v = getVel(y, step)
% get features' first order derivative along the time dimension
if nargin < 2
    step = 1;
end
h = [1 zeros(1,step-1) -1];
v = conv2(y, h, 'valid');


end