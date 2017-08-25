% test function getInverseMomentMat

addpath(genpath(fullfile('..','..')));

y = (1:10)';
[Minv] = getInverseMomentMat(y, 2);
Gt = [
    13.8333   -5.2500    0.4167
    -5.2500    2.4129   -0.2083
    0.4167   -0.2083    0.0189 ];
e = norm(Minv - Gt, 'fro');
assert(e < 1e-4);