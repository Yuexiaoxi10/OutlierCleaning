function [Pose_UYDP,label1, gt,chunk] = getPoses(videoPrediction, label, Nvideo, fram)

     Pose_UYDP = cell(1,fram);
     gt = cell(1,fram);

for i = 1 : fram
    
     Pose_UYDP{1,i} = videoPrediction{1,(Nvideo-1)*100+i}(1:8,:);
     

end

chunk = [(Nvideo-1)*100 Nvideo*100];
label1 = label(:,:,chunk(1,1)+1:chunk(1,2));
for i = 1 : fram
    
     gtpose = label1(:,:,i);
     gtpose_re = [gtpose(1:4,:);gtpose(7,:);gtpose(5,:);gtpose(6,:);gtpose(8,:)];
     gt{1,i} = gtpose_re;
   
end
end
