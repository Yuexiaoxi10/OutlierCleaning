function poseTrackOut = propagateTrack(poseTrack, omega)
% interpolate the tracks

poseTrackOut = poseTrack;
np = size(poseTrack, 1) / 2;
nFrame = size(poseTrack, 2);
eta_max = 1;
lambda = 0.1;
winSize = 20;
stepSize = 20;
nStep = ceil((nFrame-winSize) / stepSize) + 1;
for i = 1:nStep
    for j = 1:np
        fStart = (i-1)*stepSize+1;
        fEnd = min((i-1)*stepSize+winSize, nFrame);
        xy = poseTrack(2*(j-1)+1:2*j, fStart:fEnd);
        om = omega(fStart:fEnd);
%         [xy_hat,eta] = fast_incremental_hstln_mo(xy,eta_max,'omega',om);
        xyMean = mean(xy(:, om==1), 2);
        xy(:, om==1) = bsxfun(@minus, xy(:, om==1), xyMean);
        xy_hat = l2_fastalm_mo(xy,lambda,'omega',om);
        xy_hat = bsxfun(@plus, xy_hat, xyMean);
        poseTrackOut(2*(j-1)+1:2*j, fStart:fEnd) = xy_hat;
    end
end

end