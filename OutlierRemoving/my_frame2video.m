%function my_frame2video(MF,reptition,videoname)
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