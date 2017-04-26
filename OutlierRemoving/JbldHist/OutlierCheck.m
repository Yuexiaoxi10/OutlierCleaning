 Nvideo = 13;
fram = 100;np = 8;fr = 10; dt = 2;
threshVal = 20;
JbldTesting = struct;
 Nvid = 20;
 %%
% for Nvideo = 1 : Nvid

[Pose_UYDP,chunk, label1, gt] = getPoses(videoPrediction_UYDP, label, Nvideo, fram);
Pose_UYDP_flip = flip(Pose_UYDP);
gt_flip = flip(gt);

%%
 Jbld_test = Jbld_total(Nvideo).Jbld;
Jbld_test_fl = Jbld_total(Nvideo).Jbld_flip;

Distance = zeros(np,fram);% distance btw detection & gt

outFram = cell(1,np); % all outliers frames when dis > threshValue
outFram1 = cell(1,np); % outlier frames after 10 frames with odd number
JbldVal = cell(1,np);
testJbld = cell(1,np);

for ii = 1 : fram
     dis = gt{1,ii} - Pose_UYDP{1,ii};
%    dis = gt_flip{1,ii} - Pose_UYDP_flip{1,ii};
   Dis = sqrt(dis(:,1).^2+dis(:,2).^2);
   Distance(:,ii) = Dis; % 
   
end
%%
for k = 1 : np
        disRow = Distance(k,:);
        c = find(disRow > threshVal);
        outFram{1,k} = c;
        c1 = c(mod(c,2)==0);
        c2 = c1(find(c1>10));
         outFram1{1,k} = c2;
       %
       ithFr = outFram1{1,k};% ith frames with outliers
       ith = (ithFr - fr)/2; % ith Jbld 
    
      JbldVal{1,k} = Jbld_test_fl{1,k}(ith,:); % ith outlier-Jbld Value
      testJbld{1,k} = setdiff(Jbld_test_fl{1,k},JbldVal{1,k}); % rest of Jbld values 
    
       
end
   
 


JbldTesting(Nvideo).JbldVal = JbldVal;
JbldTesting(Nvideo).JbldRest = testJbld;


 

 
% end

%% concatenates all Jbld values over all videos

Jbld_Nvid = cell(1,Nvid);
JbldRest_Nvid = cell(1,Nvid);

cat_Jbld = cell(1,np);
cat_JbldRest = cell(1,np);


 for N = 1 : np
    
    for Nvideo = 1 : Nvid
        JbldVal = JbldTesting(Nvideo).JbldVal;
        JbldRest = JbldTesting(Nvideo).JbldRest;

        
        Jbld_Nvid{1,Nvideo} = JbldVal{1,N};
        JbldRest_Nvid{1,Nvideo} = JbldRest{1,N};
        
    end
%         C = cat(1,Jbld_Nvid{:});
%         cat_Jbld{1,N} = C;
%         
%         C2 = cat(1,JbldRest_Nvid{:});
%         cat_JbldRest{1,N} = C2;
 end

%%
figure(1)
subplot(2,2,1)
h11 = histogram(cat_Jbld{1,1}); hold on
h12 = histogram(cat_JbldRest{1,1});
title('Head');
legend('Outlier Jbld','Rest Jbld');

subplot(2,2,2)
h21 = histogram(cat_Jbld{1,2}); hold on
h22 = histogram(cat_JbldRest{1,2});
title('Neck');
legend('Outlier Jbld','Rest Jbld');

subplot(2,2,3)
h31 = histogram(cat_Jbld{1,3}); hold on
h32 = histogram(cat_JbldRest{1,3});
title('Left Shoulder');
legend('Outlier Jbld','Rest Jbld');


subplot(2,2,4)
h41 = histogram(cat_Jbld{1,6}); hold on
h42 = histogram(cat_JbldRest{1,6});
title('Right Shoulder');
legend('Outlier Jbld','Rest Jbld');


figure(2)
subplot(2,2,1)
h51 = histogram(cat_Jbld{1,4}); hold on
h52 = histogram(cat_JbldRest{1,4});
title('Left Elbow');
legend('Outlier Jbld','Rest Jbld');

subplot(2,2,2)
h61 = histogram(cat_Jbld{1,5}); hold on
h62 = histogram(cat_JbldRest{1,5});
title('Left Wrist');
legend('Outlier Jbld','Rest Jbld');

subplot(2,2,3)
h71 = histogram(cat_Jbld{1,7}); hold on
h72 = histogram(cat_JbldRest{1,7});
title('Right Elbow');
legend('Outlier Jbld','Rest Jbld');


subplot(2,2,4)
h81 = histogram(cat_Jbld{1,8}); hold on
h82 = histogram(cat_JbldRest{1,8});
title('Right Wrist');
legend('Outlier Jbld','Rest Jbld');


