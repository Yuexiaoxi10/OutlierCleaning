function [cleanedTraject,video_track] = getcleanTraject(Batch, fileRoot)

filePath = [fileRoot,'Batch',num2str(Batch),'/'];
%fileName = fullfile(filePath,['Results_Batch',num2str(Batch),'.mat']);
resultName = ['video_track_pose_center_b',num2str(Batch),'.mat'];
fileName = fullfile([filePath,'/',resultName]);
load(fileName);

%addpath(genpath('~/Documents/LabLife/Reaserch/SpringforPhD/CPM/testing/'));
%param = config();

order = 2;
lambda = 1;
numVid = 1;
cleanedTraject(1:length(video_track)) = struct('vidName',[],'traject',[]);

for Nvideo = numVid : length(video_track)
        fprintf('video:%d/%d \n', Nvideo, length(video_track));
        %tic;
    
        Prediction = video_track(Nvideo).prediction;
        Rect = video_track(Nvideo).annorect;
        Traj(1:length(Rect)) = struct('trj',[]);
        for nPerson = 1 : length(Rect)
            videoPrediction = Prediction(nPerson).pred;
            njt = size(videoPrediction{1,1},1); % number of joints
            Joint_Frm = cell(1, njt);
            frame = length(videoPrediction);
            dtTemp = cell2mat(videoPrediction);
            for j = 1:njt
                Joint_Frm{j} = reshape(dtTemp(j, :), 2, []);
            end
                Trajec_new = cell(1, njt);
                Omega = cell(1, njt);
            for j = 1 : njt
                [omegaX, pX, cntX] = outlierDetectionSOS(Joint_Frm{1,j}(1,:), order+1);
                [omegaY, pY, cntY] = outlierDetectionSOS(Joint_Frm{1,j}(2,:), order+1);
                omega = double(omegaX & omegaY);
                Trajec_new{j} = l2_fastalm_mo(Joint_Frm{1,j},lambda,'omega',omega);
                Omega{j} = omega;
            end


            NewTraj = cell(1,frame);
            pose = zeros(njt,2);
            for i = 1 : frame
    
   
                for j = 1 : njt
                    joint = Trajec_new{1,j}(:,i);
                    pose(j,:) = joint';
       
        
                end
    
                NewTraj{1,i} = pose;
     
            end
            Traj(nPerson).trj = NewTraj;
            clear NewTraj
    
        end
    cleanedTraject(Nvideo).vidName = video_track(Nvideo).vidName;
    cleanedTraject(Nvideo).traject = Traj;
    cleanedTraject(Nvideo).keyframe = video_track(Nvideo).keyframe;
    clear Traj
    %toc;
end
end