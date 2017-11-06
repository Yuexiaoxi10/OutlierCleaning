close 
jt = 4;
Joint = Joint_Frm{1,jt};
order = 2;
% figure;
% plot(Joint(1,:),'r-*');


%%
close
lambda = 0.05;
[omegaX, pX, cntX] = outlierDetectionSOS(Joint_Frm{1,jt}(1,:), order+1);
[omegaY, pY, cntY] = outlierDetectionSOS(Joint_Frm{1,jt}(2,:), order+1);
 omega = double(omegaX & omegaY);
Trajec = l2_fastalm_mo(Joint_Frm{1,jt},lambda,'omega',omega);

figure(1)
plot(Joint(1,:),'r-*'),hold on
plot(Trajec(1,:),'b-o');

%%

