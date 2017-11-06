% For video 00091975
% take look at joint #3,4,5
jt = 4;
dim = 1;% x or y
Joint = Joint_Frm{1,jt};
%{
figure(1)
plot(Joint(dim,:),'r-*');
ylim([600 1500]);
%ylim([min(Joint(dim,:))+5 max(Joint(dim,:))+5]);
%}
%%
close 
lambda = 1;
%for jt = 4 : 5
[omegaX, pX, cntX] = outlierDetectionSOS(Joint_Frm{1,jt}(1,:), order+1);
[omegaY, pY, cntY] = outlierDetectionSOS(Joint_Frm{1,jt}(2,:), order+1);
omega = double(omegaX & omegaY);
 Trajec = l2_fastalm_mo(Joint_Frm{1,jt},lambda,'omega',omega);
 
 %Trajec_new{1,jt} = Trajec;
%end

 figure(2)
 plot(Joint(dim,:),'r-*'),hold on
 plot(Trajec(dim,:),'b-o');
 %ylim([min(Joint(dim,:))-10 max(Joint(dim,:))+10]);
 