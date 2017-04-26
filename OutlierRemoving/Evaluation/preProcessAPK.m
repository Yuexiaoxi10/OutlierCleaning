
function [gt_pose, Detection, inputDet] = preProcessAPK(label,DetectedPose,videoPrediction)
% load('label.mat');
% np: number of joints
% NumDet: number of frames
np = length(DetectedPose);
%   NumDet = size(DetectedPose(1).data,2);
  NumDet = size(DetectedPose{1,1},2); % for 1-by-1 code

gt_pose = struct;
for i = 1 : NumDet
    
    gtPose = label(1:np,:,i);
    gtPose_re = [gtPose(1:4,:);gtPose(7,:);gtPose(5,:);gtPose(6,:);gtPose(8,:)];
    gt_pose(i).point = gtPose_re;
    
%      for ii = 1 : 8
%         
%         gt_head(ii).point(:,i) = gtPose(:,ii);
%      end
    
end

Detection = struct;
for ii = 1 : np
%     
%      DetPose = DetectedPose(ii).data';
%     for iii =  1 : NumDet
%          Detection(iii).point(ii,:) = DetPose(iii,:);
%     end

% For 1-by-1 code
  DetPose = DetectedPose{1,ii};
  
  for iii = 1 : NumDet
     
        Detection(iii).point(ii,:) = DetPose(:,iii);
  
  end
10;



end

inputDet = struct;

for i = 1 : NumDet
    
    inputPose = videoPrediction{1,i};
    inputDet(i).point = inputPose;
    
    
    
end
end
