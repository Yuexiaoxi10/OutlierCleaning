clc
clear all
% matlabpool open;
%% Read training data
pos = cell(0);
m = 40;
n = 100;
sliding_W = 15;

for i=1:400
    
tmpfilename=strcat('/Users/Goo/Develop/xuefengproject/image/CarData/TrainImages/pos-',int2str(pickfile(i)), '.pgm');
test_image=imread(tmpfilename);
bw=edge(test_image,'canny',[],0.8);
% r=extract_contoursnew(bw);
[r,~]=extract_contourSW(bw,sliding_W);
close all
r=r';
% transfer(['SVM_pos/pos-',int2str(i),'.txt'],r,'test',m,n);

pos = [pos;r];
disp(i);
end
transfer('positive.txt',pos,'train',m,n);


neg = cell(0);
parfor i=1:400
tmpfilename=strcat('/Users/Goo/Develop/xuefengproject/image/CarData/TrainImages/neg-',int2str(pickfile(i)), '.pgm');
test_image=imread(tmpfilename);
bw=edge(test_image,'canny',[],0.8);
% r=extract_contoursnew(bw);
[r,~]=extract_contourSW(bw,sliding_W);
close all
r=r';
% transfer(['SVM_neg/neg-',int2str(i),'.txt'],r,'test',m,n);

neg = [neg;r];
disp(i);
end
transfer('negtive.txt',neg,'train',m,n);

matlabpool close;
%% Read Testing data
for i=0:169
    tmpfilename=strcat('/Users/Goo/Develop/xuefengproject/image/CarData/TestImages/test-',int2str(i), '.pgm');
    test_image=imread(tmpfilename);
    [m,n] = size(test_image); 
    bw=edge(test_image,'canny',[],0.8);
    r=extract_contourSW(bw,sliding_W);
%     r=extract_contoursnew(bw);
%     r=extract_contours_noclean(bw);
%     Z=getframe(gcf);
%     imwrite(Z.cdata,['TestContour/contour-',int2str(i), '.jpg'],'Quality',100);
    close all
    r=r';
    transfer(['TestImg/test-',int2str(i),'.txt'],r,'test',m,n);
end
% lengthfiles=length(files);
% for i=1:lengthfiles;
%     
%  test_image=imread('/Users/xuefenghan/Documents/Project/image/CarData/TrainImages',files(i).name);
% %  test_image=rgb2gray(test_image);
%   bw=edge(test_image,'canny');
% %imshow(test_contour);
%  r=extract_contours(bw);
%  r=r';
%  transfer('result',r);
% end