% test SOS

addpath(genpath(fullfile('..','..')));

y = (1:10)';

nVar = size(y, 2);
mOrd = 2;
[basis,~] = momentPowers(0, nVar, mOrd);
[Minv] = getInverseMomentMat(y, mOrd);

x = 11;
v = prod( bsxfun( @power, x, basis), 2);
P = v' * Minv * v;
thres = nchoosek(mOrd+nVar, mOrd);