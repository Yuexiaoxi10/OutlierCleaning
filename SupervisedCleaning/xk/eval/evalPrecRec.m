function [prec, rec] = evalPrecRec(gtJoint, ysTest, ysClean, outlierThres)

if nargin < 4
    outlierThres = 20;
end

o1 = zeros(size(gtJoint));
o2 = zeros(size(gtJoint));
o1(abs(ysTest-gtJoint) > outlierThres) = 1;
o2(abs(ysClean-gtJoint) > outlierThres) = 1;
tp = nnz(o1==1 & o2==0);
fp = nnz(o1==0 & o2==1);
fn = nnz(o1==1 & o2==1);
prec = tp / (tp + fp + eps);
rec = tp / (tp + fn + eps);

end