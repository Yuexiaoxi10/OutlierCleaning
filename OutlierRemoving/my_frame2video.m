function my_frame2video(MF,reptition,videoname)


writerObj = VideoWriter(videoname);
open(writerObj);
for k = 1 : length(MF)
    if ~isempty(MF(k).cdata)
        for j = 1 : reptition
            writeVideo(writerObj,MF(k).cdata);
        end
    end
end
close(writerObj);

end