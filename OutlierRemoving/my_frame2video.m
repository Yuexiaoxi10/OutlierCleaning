<<<<<<< HEAD
=======
%function my_frame2video(MF,reptition,videoname)
>>>>>>> c1ddbc8132eea2172f84aa12a9c141a70e37e5ac
function my_frame2video(MF,videoname)


writerObj = VideoWriter(videoname);
vidObj.FrameRate = 5;
open(writerObj);
for k = 1 : length(MF)
    
    if ~isempty(MF(k).cdata)
        %for j = 1 : reptition
            writeVideo(writerObj,MF(k).cdata);
        %end
    end
    
end
close(writerObj);

end