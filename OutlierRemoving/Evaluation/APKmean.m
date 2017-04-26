
function [mean_h, mean_al,mean_sh,mean_tot] = APKmean(APK)
mean_h = mean(APK(:,1)); %head
% 
Albow  = [APK(:,4) APK(:,7)];%albow
mean_al = mean(mean(Albow));

Shoulder = [APK(:,3) APK(:,6)];%shoulder
mean_sh = mean(mean(Shoulder));

mean_tot = mean(mean(APK));
end
