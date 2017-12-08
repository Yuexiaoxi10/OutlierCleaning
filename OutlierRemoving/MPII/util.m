fileRoot = '/home/yuexi/Documents/CPM/VideoResults/';
load([fileRoot,'Result_MPII_single.mat']);
for Batch = 1 : 15
    
    filePath = [fileRoot,'Batch',num2str(Batch),'/'];
    resultName = ['video_track_pose_center_b',num2str(Batch),'.mat'];
    fileName = fullfile([filePath,'/',resultName]);
    load(fileName);%orginal detections
    for Nvideo = 1 : length(video_track)
        %compareTraject(Nvideo).traj = Result_single(Batch).Batch(Nvideo).traj;
        %compareTraject(Nvideo).keyframe = Result_single(Batch).Batch(Nvideo).keyframe;
        %compareTraject(Nvideo).vidName = video_track(Nvideo).vidName;
        Result_single(Batch).Batch(Nvideo).vidName = video_track(Nvideo).vidName;
    end
    %Result_single(Batch).Batch = compareTraject;
    
end

save([fileRoot,'Result_MPII_single.mat'],'Result_single');