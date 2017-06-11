function acc = computeAccuracy(yc, gt, thres)
% function acc=computeAccuracy(yc, gt, thres)
% compare yclean and the groundtruth gt and return the accuracy
% Inputs:
% yc: output of the cleaned data, d-by-n matrix, d is the two times the
% number of joints, n is the number of frames
% gt: ground truth locations of joints, d-by-n matrix, d is the two times the
% number of joints, n is the number of frames
% thres: the threshold of whether or not count some joint as correct,
% positive scalar real number
% Outputs:
% acc: accuracy

[d, n] = size(yc);
[d2, n2] = size(gt);
assert(d==d2);
assert(n==n2);
assert(mod(d,2)==0);
np = d / 2;
e = abs(yc-gt);
ex = e(1:2:end, :);
ey = e(2:2:end, :);
ed = (ex.^2+ey.^2).^0.5;
nCorrect = sum(ed(:) < thres);
nTotal = np * n;
acc = nCorrect / nTotal;

end