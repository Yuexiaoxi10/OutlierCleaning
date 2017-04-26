%%
%  load('./Results/NewTrajectory.mat');
 load('./InputData/param_visu.mat');
 %%
fram = 100;np = 8;
NewTrajc = struct;
Trajc1 = cell(1,fram);
poseNew = zeros(np,2);

for i = 1 : length(NewTrajectory_sr)
    Trajec = NewTrajectory_sr(i).Trajec;
    
    for k = 1 : fram
        
       for kk = 1 : np
           
           poseNew(kk,:) = Trajec{1,kk}(:,k)';
                 
       end
       Trajc1{1,k} = poseNew;
    end
    
    NewTrajc(i).videos = Trajc1;
end



%%
close all
clear MFV_test
Nvideo = 3;
% Trajc1 = NewTrajc(Nvideo).videos;
picpath = './frames/';
imlist = dir(fullfile(picpath, '*.jpg'));
ind = (Nvideo-1)*100;
Trajc1 = NewTrajc(Nvideo).videos;

 for i = ind+1 : Nvideo*100
%  for   i = ind + 20 : ind + 40
    test_image = fullfile(picpath,imlist(i).name);
    
%       pose = videoPrediction_UYDP{1,i}(1:8,:);% pose from detection
      pose = Trajc1{1,i-ind};% pose after completion

      visualizeSkeleton(test_image,pose,param_visu);

     
        title([num2str(i-ind) '/' num2str(fram)],'Color','r','FontSize',25);
%         title('Cleaned Trajectory');
      MFV_test(i) = getframe(gcf);
    
  pause(0.05)
end

 ax = gca;
 ax.Color = 'none';

%   my_frame2video(MFV_test,8,'./Results/videoResults/v13/UYDP_v13_comp_clip1');
% my_frame2video(MFV_test,8,'./Results/videoResults/V12/UYDP_v12_comp_clip1');







