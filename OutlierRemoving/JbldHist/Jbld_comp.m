Nvideo = 19;

outlier = ithOutlier(Nvideo).outlier;
outlier_flip = ithOutlier(Nvideo).outlier_flip;
 Jbld_vid = Jbld_total(Nvideo).Jbld;
 Jbld_vid_fl = Jbld_total(Nvideo).Jbld_flip;
% Jbld_vid = SOS_total(Nvideo).SOS;
% Jbld_vid_fl = SOS_total(Nvideo).SOS_flip;
%% for each joint
npart = 3 ; % 1-8th joint
ith_jt = outlier{1,npart};
ith_jt_fl = outlier_flip{1,npart};
Jbld_jt = zeros(length(ith_jt),1);
Jbld_jt_fl = zeros(length(ith_jt_fl),1);


for i = 1 : length(ith_jt)
    
    Jbld_jt(i) = Jbld_vid{1,npart}(ith_jt(i),:);
    
end
Jbld_jt_re = setdiff(Jbld_vid{1,npart},Jbld_jt);


for ii = 1 : length(ith_jt_fl)
    
    Jbld_jt_fl(ii) = Jbld_vid_fl{1,npart}(ith_jt_fl(ii),:);
    

end

Jbld_jt_re_fl = setdiff(Jbld_vid_fl{1,npart},Jbld_jt_fl);


figure(1)
subplot(2,1,1)
histogram(Jbld_jt,16),hold on
histogram(Jbld_jt_re,16)
legend('Outlier Jbld','Rest Jbld');
title('Forward');

subplot(2,1,2)
histogram(Jbld_jt_fl,16),hold on
histogram(Jbld_jt_re_fl,16)
legend('Outlier Jbld','Rest Jbld');
title('Backward');
