function alpha = estimateAlpha(p1, p2)
% function estimateAlpha
% estimate the time warping ratio between two systems by comparing two
% group of poles
% Inputs:
% p1: poles of system 1
% p2: poles of system 2
% Output:
% alpha: time warping ratio

assert(iscolumn(p1));
assert(iscolumn(p2));

% sort estimated poles of the known model
p1 = sortPole(p1);
p2 = sortPole(p2);

% estimate the ratio as the mean of ratios
alpha = abs(mean(log(p2)./log(p1)));

end