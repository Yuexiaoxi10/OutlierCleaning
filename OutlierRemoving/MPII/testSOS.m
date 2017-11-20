

Nvideo = numVid;
nPerson = 1;

Prediction = video_track(Nvideo).prediction;

videoPrediction = Prediction(nPerson).pred;
njt = size(videoPrediction{1,1},1); % number of joints
Joint_Frm = cell(1, njt);
dtTemp = cell2mat(videoPrediction);
for j = 1:njt
    Joint_Frm{j} = reshape(dtTemp(j, :), 2, []);
end
%%


lambda = 1;
%for jt = 4 : 5

close 
jt = 10;
Joint = Joint_Frm{1,jt};
order = 2;
% figure;
% plot(Joint(1,:),'r-*');


[omegaX, pX, cntX] = outlierDetectionSOS(Joint_Frm{1,jt}(1,:), order+1);
[omegaY, pY, cntY] = outlierDetectionSOS(Joint_Frm{1,jt}(2,:), order+1);
 omega = double(omegaX & omegaY);
Trajec = l2_fastalm_mo(Joint_Frm{1,jt},lambda,'omega',omega);

figure(1)
plot(Joint(1,:),'r-*'),hold on
plot(Trajec(1,:),'b-o');

%%

