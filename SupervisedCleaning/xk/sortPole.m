function pSort = sortPole(p)
% sort poles, first according to angles then according to magnitude
% Input:
% p: a column vector containing poles
% Output:
% pSort: sorted poles

assert(iscolumn(p));

r = abs(p);
theta = angle(p);
M = [theta, r];
[~, ind] = sortrows(M);
pSort = p(ind);

end