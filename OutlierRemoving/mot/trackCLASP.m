close all
clear
dbstop if error;
%fclose(ID);
addpath(genpath('../../3rdParty'));

filePath = '/Users/yuexizhang/Documents/CLASP_Labeling/CLASP7910/07212017_EXPERIMENT_9A_Aug7/mp4s/C9_frames/tags';
fileName = dir(fullfile(filePath,'*.jpg.txt'));
imgPath = '/Users/yuexizhang/Documents/CLASP_Labeling/CLASP7910/07212017_EXPERIMENT_9A_Aug7/mp4s/C9_frames';
imgFiles = dir(fullfile(imgPath,'*.jpg'));

%ID = fopen(fullfile(filePath,'Frame1080.jpg.txt'));

%%

patchSize = 100;
for i = 1 : length(imgFiles)
Person = [];
%for i = 1 : 50
    
ID = fopen(fullfile(filePath,fileName(i).name));
img = imread(fullfile(imgPath,imgFiles(i).name));
Q = fgets(ID);
A = textscan(ID, '%s %d %d %d %d %d %d %d %d %d %d %d \n');


personID = cellfun(@(x) strcmp(x,'person'), A{1});
LocAll = double([A{1,2:end}]);
LocPerson = LocAll(personID,1:4); % x_tl,y_tl,w,h
if ~isempty(LocPerson)
    nPerson = size(LocPerson,1);
    %img = imread(fullfile(imgPath,imlist(i).name));
    for k = 1 : nPerson % counting how many persons in one frame
     Posx = LocPerson(k,1)+0.5*LocPerson(k,3);% x = x_tl + 0.5*w
     Posy = LocPerson(k,2)+0.5*LocPerson(k,4);% y = y_tl + 0.5*h
     xy = [Posx';Posy'];
     Person(k).joint.xy = xy; % joint here is centroid of the bbx;
     Person(k).joint.appr = getFeature(img,xy,patchSize);
    end
    Detection(i).person = Person;
end
 %centroid
 Loc(i).person = LocPerson;

fclose(ID);
end
%%
% close all
opt.costThres = 1.2;
opt.lambda = 1;
poseTracklet = associatePose(Detection, opt);
poseTrack = poseTracklet;

% display the trackes superposed on video
 displayPoseTrack(imgPath, poseTrack, true);









