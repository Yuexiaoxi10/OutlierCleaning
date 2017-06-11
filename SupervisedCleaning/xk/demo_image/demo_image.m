 clear;
close all;

%%%% REQUIREMENTS
% Before running this script, you need to do the following:
% 1) download and extract the following packages into the working directory:
%    - MOCAP (0.136) and NDLUTIL (0.161) at http://staffwww.dcs.shef.ac.uk/people/N.Lawrence/mocap/
%    - the camera calibration toolbox at http://www.vision.caltech.edu/bouguetj/calib_doc/download/index.html
% 2) run the 'BerkeleyMHAD_download.bat' script to download the test data into the working directory
% 3) now you can just run this script
%
%%%% NOTES
% 1) Make sure to include 'bvh2xyz.m' that comes with the download in your working directory so that it will override calls to the original from the MOCAP package.
% 2) Make sure to include 'project_points.m' that comes with the download in your working directory so that it will override calls to the original from the Camera Calibration Toolbox.
%
% Updated: 2017/01/11


% addpath 'MOCAP0p136';
addpath(genpath('lawrennd-mocap-7e19233'));
addpath(genpath('bvh-matlab'));
addpath 'NDLUTIL0p161';
addpath 'toolbox_calib';
rootPath = '~/research/code/OutlierCleaning';
addpath(genpath(fullfile(rootPath, '3rdParty')));
addpath(genpath(fullfile(rootPath, 'SupervisedCleaning/xk')));

% set this flag to 1 if you want to save the demo as a video
v = 0;

% selected subject - action - recording
s = 1;
a = 1;
r = 1;

drc = '~/research/data/BerkeleyMHAD';

% load image-mocap correspondences, i.e., the set of mocap frames closest
% to the given set of image frames
im_mc = load(sprintf('%s/Camera/Correspondences/corr_moc_img_s%02d_a%02d_r%02d.txt',drc,s,a,r));

% load mocap data
moc_data = load(sprintf('%s/Mocap/OpticalData/moc_s%02d_a%02d_r%02d.txt',drc,s,a,r));

% load skeleton data
[skel,channel,framerate] = bvhReadFile(sprintf('%s/Mocap/SkeletalData/skl_s%02d_a%02d_r%02d.bvh',drc,s,a,r));
skel_jnt = 10*chan2xyz(skel,channel);
% temp = chan2xyz(skel,channel);
% offset = repmat(skel.tree(1).offset, 1, 35);
% temp = bsxfun(@minus, temp, offset);
% skel_jnt = 10 * temp;

calib_params;

% Homogeneous transformation matrix from world coordinate frame to camera
% coordinate frame, 
H = L(1).C(1).T*L(1).T;
om = rodrigues(H(1:3,1:3));
T  = H(1:3,4);
f  = [L(1).C(1).K(1,1); L(1).C(1).K(2,2)];
c  = L(1).C(1).K(1:2,3);
k  = L(1).C(1).d;
    

%%
% create movie object
if v,
    movobj = VideoWriter('demo_image','MPEG-4');
    movobj.FrameRate = 10;
    open(movobj);
end

hf = figure('Position',[100,100,640,480]);

for i=1:size(im_mc,1),
    
    % get the mocap frame
    moc = reshape(moc_data(im_mc(i,3)+1,1:end-2),3,[]);
    
    % get the skeleton frame
    jnt = reshape(skel_jnt(im_mc(i,3)+1,:),3,[]);
%     jnt = bsxfun(@plus, jnt, [-520; -873; 143]);
    
    % read in the depth data
    d1 = imread(sprintf('%s/Camera/Cluster01/Cam01/S%02d/A%02d/R%02d/img_l01_c01_s%02d_a%02d_r%02d_%05d.pgm',drc,s,a,r,s,a,r,i-1));
    d1 = demosaic(d1,'grbg');

    % project 3D points onto image plane
    DM = project_points(moc,om,T,f,c,k);
    DJ = project_points(jnt,om,T,f,c,k);
    
    % plot the mocap markers and joint positions onto the image frame
    figure(1)
    imshow(d1)
    hold on;
    plot(DM(1,:),DM(2,:),'ob');
    plot(DJ(1,:),DJ(2,:),'+r');
    hold off;
    
    pause(0.1);
    
    if v,
        gf = getframe(get(hf,'CurrentAxes'));
        writeVideo(movobj,im2frame(gf.cdata(1:480,1:640,:),gf.colormap));
    end
    
end

if v, close(movobj); end

close(1);