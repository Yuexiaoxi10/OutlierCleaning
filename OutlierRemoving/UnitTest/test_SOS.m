% test SOS

[cwd] = fileparts(mfilename('fullpath'));
cd(cwd);
addpath(genpath(fullfile('..','..','3rdParty')));
addpath(genpath(fullfile('..','..','OutlierRemoving')));

y = (1:10)';
y = y + 0.1 * randn(size(y));
Hy = hankel(y(1:3), y(3:end));

nVar = size(Hy, 1);
mOrd = 2;
[basis,~] = momentPowers(0, nVar, mOrd);
[L,Minv] = getInverseMomentMat(Hy', mOrd);

x = [9; 10; 11];
v = prod( bsxfun( @power, x', basis), 2);
P = v' * Minv * v;
u = L * v;
q = sum(u.^2);
thres = nchoosek(mOrd+nVar, mOrd);