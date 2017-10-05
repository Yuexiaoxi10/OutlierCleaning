function trackletsClean = cleanTracklet(tracklets)
% this function cleans each tracklet
% Given a tracklet, there may be some outlier pose in some joints in some
% frames, so we use JBLD+SOS to detect the outliers, then treat the
% outlier points as missing data and use some method to interpolate it
% Input: tracklets, is struct array of tracklets
% Output: trackletsClean, is struct array of the same size as the input,
% cleaned tracklets.

lambda = 1;
lambda1 = 10;
lambda2 = 1e10;
minLen = 20;

trackletsClean = tracklets;
for i = 1:length(tracklets)
    currTracklet = tracklets(i).data;
    np = size(currTracklet, 1) / 2;
    
    % ALM
    nFrame = tracklets(i).length;
    if nFrame < minLen
        trackletsClean(i).data = currTracklet;
        continue;
    end
    [Jbld, SOS_score, Outlier, Joint_Frm] = OutlierDet2(currTracklet);
    currTrackletClean = zeros(size(currTracklet));
    Omega = cell(1,np);
    for j = 1:np
        oInd = Outlier{j};
        omega = ones(1,nFrame);
        omega(oInd) = 0; % set omega equals to 0 at the frame of outlier
        Omega{j} = omega;
        currTrackletClean(2*(j-1)+1:2*j, :) = l2_fastalm_mo(Joint_Frm{j},lambda,'omega',Omega{j});
    end
    trackletsClean(i).data = currTrackletClean;
    
% %     SRPCA
%     currTrackletClean = zeros(size(currTracklet));
%     for j = 1:np
%         jointTraj = currTracklet(2*(j-1)+1:2*j, :)';
%         mask = ones(size(jointTraj));
%         jointTrajClean = SRPCA_e1_e2_clean_md(jointTraj, lambda, lambda2, mask);
%         currTrackletClean(2*(j-1)+1:2*j, :) = jointTrajClean';
%     end
%     trackletsClean(i).data = currTrackletClean;
end

end