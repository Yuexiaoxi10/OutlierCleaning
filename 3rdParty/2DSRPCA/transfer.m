
%this function use for transfer the file into a txt file or default file
%the input is var should be an cell, in each cell contain the information
%of trajectoy.  The input information is N*1 cell, each cell is M*2 matrix
%fileName is the txt file name you want to write into.
%type: 'test'-testing file
%      'train'-training file
% output is txt file
% outpur format is :
% first line:total number of trajectory
% second line: first number is point number of first trajectory
% third line: first number is point number of second trajectory
%.... until to the last trajectory
%%
function transfer(fileName, var, type, row, col)

fid = fopen(fileName, 'w');
%write the total number of contour
fprintf(fid,'%u\n',size(var,1));
if strcmp(type, 'test')
    fprintf(fid,'%u\n',row);
    fprintf(fid,'%u\n',col);
end
%write the number of points
for i=1:size(var,1);
    
    fprintf(fid,'%d',size(var{i,1},1));
    %write the coodinate of points
    for j=1:size(var{i,1},1);
        
        fprintf(fid,' %f %f',var{i,1}(j,2),var{i,1}(j,1));
        %fprintf(fid,'%u\n',var{end,i});
    end
    fprintf(fid,'\n');
end

fclose(fid);
end
