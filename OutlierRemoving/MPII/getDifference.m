

fileRoot = '/media/DATAPART1/yuexi/CPM/VideoResults/';
Picroot = '/media/DATAPART1/yuexi/Data/';
addpath('/media/DATAPART1/yuexi/CPM/testing');
addpath(genpath('../../OutlierRemoving'));
param = config();
%%
for Batch = 17;
    compareTraject = Result_single(Batch).Batch;
    numVid = length(compareTraject);
    Difference = zeros(numVid,1);
    for vidNum = 1 : numVid
        Traject_comp = compareTraject(vidNum).traj;
    
        for nPerson = 1 : length(Traject_comp)
        
            OriginTraj = Traject_comp(nPerson).origin;
            CleanedTraj = Traject_comp(nPerson).cleaned;
            diff = norm(CleanedTraj-OriginTraj,'fro');
        
        end
        Difference(vidNum,1) = diff;
        clear diff
    end
end
%%
index = find(Difference >= 80);
for Batch = 17 %: 25
    clear compareTraject
    PicPath = [Picroot,num2str(Batch),'/'];
    
    
    compareTraject = Result_single(Batch).Batch;

    for nvid = 1 : length(index)
        figure(1)
        imPath = [PicPath,compareTraject(index(nvid)).vidName];
        imlist = dir(fullfile(imPath,'*.jpg'));
        keyframe = compareTraject(index(nvid)).keyframe;
        keyInd = find(strcmp({imlist.name}, keyframe)==1);
        Traject_comp = compareTraject(index(nvid)).traj;
        compareTraj = cell(length(Traject_comp),2);
        Title = {'Original Detection','Cleaned Detection'};
        for i = 1 : 2
            hold off
            subplot(2,1,i)
           
          
            image = [imPath,'/',imlist(keyInd).name];
            img = imread(image);
            imshow(img)
            
            %title([num2str(keyInd),'/',num2str(length(imlist))]);
            title(['Video:',num2str(index(nvid)),'  ',Title{1,i}]);
            hold on;
            for nPerson = 1 : length(Traject_comp)
                compareTraj{nPerson,1} = Traject_comp(nPerson).origin;
                
                compareTraj{nPerson,2} = Traject_comp(nPerson).cleaned;
                
                
                visualizeSkeleton(compareTraj{nPerson,i}, param);
            
            end
     
        end
        pause;
        
        
        
    end
end

















